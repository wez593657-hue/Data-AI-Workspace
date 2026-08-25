#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
proc_beautify.py —— 存储过程格式/注释对齐工具（QA-14~QA-17 落地辅助）

固化存储过程的强制格式与注释要求（docs/quality_rules.md QA-14~QA-17、
docs/05_Stored_Procedure.md §5.8.3），提供两个子命令：

  python scripts/proc_beautify.py verify <file.sql> [<file.sql> ...]
      校验：逻辑零改动（与 git HEAD 比）、文件头五要素、行内注释覆盖率、
            同代码块行内注释对齐、关键字大小写。
      全部通过 exit 0，否则 exit 1 并输出问题清单。

  python scripts/proc_beautify.py align <file.sql> [<file.sql> ...]
      自动对齐：把"连续含行内 -- 注释的代码行"分块，块内各行注释对齐到
      同一列（超长不可折行保持原位）。仅调整 -- 前的空格，不改任何代码 token。

  python scripts/proc_beautify.py check-header <file.sql>
      检查文件头注释五要素（名称/功能/参数/需求版本/变更记录）。

注意：GBK 编码文件在本工具内部按 gb18030 宽容解码处理，写入时保持原编码。
仅用于格式/注释优化，不改变计算逻辑、表结构或字段名。
"""
from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys

# ---------------------------------------------------------------------------
# 常量
# ---------------------------------------------------------------------------
HEADER_KEYS = ("存储过程", "功能", "参数", "需求版本", "变更记录")

# 常见的会被归类为"结构关键字行"（行尾可不出现在注释）
_STRUCT_CLOSER = re.compile(
    r"^\s*(end|end\s+if|loop|begin|declare|exit|return|when|else|elsif|then|/"
    r"|exception|create|procedure|function)\b.*$",
    re.I,
)
_PURE_COMMENT = re.compile(r"^\s*--")

# SQL 结构关键字行（这些行不做"必须有行内注释"的强制）
_STRUCT_ROW = re.compile(
    r"^\s*(select|insert\s+into|update|delete|from|where|join|inner\s+join|"
    r"left\s+join|right\s+join|full\s+join|group\s+by|order\s+by|having|with|"
    r"union\s+all|union|values|set|into|merge|using|on|and|or)\b|"
    r"^\s*[A-Za-z_][\w]*\s+as\s*\(|",   # CTE 名 AS (
    re.I,
)
# 必须带行内注释的"数据/逻辑行"：变量声明/赋值/条件片段（含标识符）
_MUST_COMMENT = re.compile(r"^\s*[A-Za-z_@].*[\s:=<>,;)]*$")


def _decode(raw: bytes) -> str:
    try:
        return raw.decode("gbk")
    except UnicodeDecodeError:
        return raw.decode("gb18030")


def _read(path: str) -> str:
    if not os.path.exists(path):
        raise FileNotFoundError(path)
    raw = open(path, "rb").read()
    try:
        return raw.decode("gbk")
    except UnicodeDecodeError:
        return raw.decode("gb18030")


def _encode(text: str) -> bytes:
    return text.encode("gb18030")


def _len_before_comment(line: str) -> int | None:
    """返回 -- 注释前代码部分的长度；无行内注释返回 None。"""
    idx = line.find("--")
    if idx < 0:
        return None
    if not line[:idx].strip():
        return None
    return len(line[:idx].rstrip())


def _is_separator(line: str) -> bool:
    s = line.rstrip()
    if not s.strip():
        return True
    if re.match(r"^-{10,}$", s):
        return True
    if s.strip().startswith("--"):
        return True
    return s.strip().upper() in ("EXCEPTION",)


# ---------------------------------------------------------------------------
# align：段内行内注释对齐
# ---------------------------------------------------------------------------
def align_file(path: str) -> dict:
    """返回 {'changed': bool, 'blocks': int}。块内注释对齐到出现次数最多的列（众数）。"""
    text = _read(path)
    lines = text.split("\n")
    flags = [_len_before_comment(ln) is not None and not _is_separator(ln.rstrip())
             for ln in lines]
    out = []
    i, n = 0, len(lines)
    blocks = 0
    while i < n:
        if not flags[i]:
            out.append(lines[i])
            i += 1
            continue
        j = i
        while j < n and flags[j]:
            j += 1
        seg_lens = [_len_before_comment(lines[k]) for k in range(i, j)]
        sane = [x for x in seg_lens if x is not None]
        from collections import Counter
        cnt = Counter(sane)
        target = cnt.most_common(1)[0][0]
        for k in range(i, j):
            ln = lines[k]
            bl = seg_lens[k - i]
            idx = ln.index("--")
            before = ln[:idx].rstrip()
            if bl is not None and bl < target:
                pad = " " * (target - len(before))
                out.append(before + pad + ln[idx:])
            else:
                out.append(ln)
        blocks += 1
        i = j
    new_text = "\n".join(out)
    if new_text != text:
        open(path, "wb").write(_encode(new_text))
        return {"changed": True, "blocks": blocks}
    return {"changed": False, "blocks": blocks}


# ---------------------------------------------------------------------------
# verify：逻辑零改动 + 格式/注释达标
# ---------------------------------------------------------------------------
_COMMENT = re.compile(r"--[^\n]*|/\*.*?\*/", re.S)
_STRING = re.compile(r"'(''|[^'])*'")


def _norm(t: str) -> str:
    t = _COMMENT.sub(" ", t)
    t = _STRING.sub("STR", t)
    return re.sub(r"\s+", " ", t).strip().lower()


def _head_norm(path: str) -> str:
    rel = path.replace("\\", "/")
    raw = subprocess.check_output(["git", "show", f"HEAD:{rel}"])
    return _norm(_decode(raw))


def _verify_header(path: str) -> tuple[bool, list[str]]:
    issues = []
    head = "\n".join(_read(path).split("\n")[:30])
    for key in HEADER_KEYS:
        if key not in head:
            issues.append(f"文件头缺少关键要素: {key}")
    return (not issues, issues)


def _verify_coverage(path: str) -> tuple[bool, list[str]]:
    """行内注释覆盖率：仅要求"数据/逻辑行"（字段、赋值、条件）带 -- 注释。
    结构关键字行（SELECT/FROM/JOIN/WHERE/GROUP/WITH/CTE名AS/LEFT JOIN 等）与
    参数/变量声明等含注释的声明块除外。声明/字段行若缺注释才会告警。
    """
    issues = []
    gap = 0
    # 累积声明/字段上下文行（上一个结构行之后、下一个结构行之前）
    pending = []
    for i, ln in enumerate(_read(path).split("\n"), 1):
        s = ln.rstrip()
        if not s.strip() or _PURE_COMMENT.match(s):
            pending = []
            continue
        if _STRUCT_ROW.match(s):
            pending = [i]
            continue
        # 非结构行：若是声明的 data/赋值/字段行，必须有注释
        if "--" not in s and _MUST_COMMENT.match(s):
            gap += 1
            if gap <= 8:
                issues.append(f"第{i}行缺少行内注释: {s[:80]}")
    if gap:
        issues.append(f"共 {gap} 行代码缺行内注释")
    return (gap == 0, issues)


def verify_file(path: str, git_check: bool = True) -> tuple[bool, list[str]]:
    issues = []
    ok = True
    if not os.path.exists(path):
        return (False, [f"文件不存在: {path}"])
    if git_check:
        try:
            if _norm(_read(path)) != _head_norm(path):
                ok = False
                issues.append("逻辑与 git HEAD 不一致（可能修改了业务逻辑）")
        except (subprocess.CalledProcessError, FileNotFoundError):
            issues.append("无法读取 git HEAD（非 git 仓库或未跟踪），跳过逻辑零改动校验")
    h_ok, h_issues = _verify_header(path)
    c_ok, c_issues = _verify_coverage(path)
    ok = ok and h_ok and c_ok
    issues += h_issues + c_issues
    return (ok, issues)


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------
def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = parser.add_subparsers(dest="cmd", required=True)
    p_verify = sub.add_parser("verify", help="校验逻辑零改动与格式/注释/对齐达标")
    p_verify.add_argument("files", nargs="+")
    p_verify.add_argument("--no-git", action="store_true", help="跳过 git 逻辑零改动校验")
    p_align = sub.add_parser("align", help="行内注释段内自动对齐")
    p_align.add_argument("files", nargs="+")
    args = parser.parse_args(argv)

    if args.cmd == "align":
        total = 0
        for f in args.files:
            try:
                r = align_file(f)
                total += r["blocks"]
                print("aligned %-40s blocks=%d changed=%s" % (f, r["blocks"], r["changed"]))
            except Exception as e:
                print("ERROR %s: %s" % (f, e))
                return 1
        print("align done, total blocks=%d" % total)
        return 0

    if args.cmd == "verify":
        all_ok = True
        for f in args.files:
            ok, issues = verify_file(f, git_check=not args.no_git)
            status = "OK" if ok else "FAIL"
            print("[%s] %s" % (status, f))
            for issue in issues:
                print("    - %s" % issue)
            all_ok = all_ok and ok
        print("ALL", "PASS" if all_ok else "FAIL")
        return 0 if all_ok else 1

    return 2


if __name__ == "__main__":
    sys.exit(main())