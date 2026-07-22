#!/usr/bin/env python3
"""Request a constrained repair patch from the configured OpenAI-compatible API."""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import urllib.error
import urllib.request
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ALLOWED_PREFIXES = (
    "data_assets/",
    "requirements/",
    "docs/",
    "templates/",
    "checklists/",
)
FORBIDDEN_PREFIXES = (
    ".github/",
    "scripts/",
    "hooks/",
    ".git/",
)
FORBIDDEN_NAMES = {".env", ".env.local", ".env.production"}


def read_text(path: str, limit: int = 30000) -> str:
    value = Path(path).read_text(encoding="utf-8", errors="replace")
    return value[-limit:]


def endpoint(base_url: str) -> str:
    base = base_url.rstrip("/")
    if base.endswith("/chat/completions"):
        return base
    return base + "/chat/completions"


def extract_json(content: str) -> dict:
    cleaned = content.strip()
    if cleaned.startswith("```"):
        cleaned = re.sub(r"^```(?:json)?\s*", "", cleaned)
        cleaned = re.sub(r"\s*```$", "", cleaned)
    value = json.loads(cleaned)
    if not isinstance(value, dict):
        raise ValueError("AI response must be a JSON object")
    return value


def validate_patch(patch: str) -> None:
    if not patch.strip():
        raise ValueError("AI did not return a patch")
    paths = re.findall(r"^(?:\+\+\+|---) [ab]/(.+)$", patch, flags=re.MULTILINE)
    if not paths:
        raise ValueError("AI response does not contain a unified diff")
    for raw_path in paths:
        path = raw_path.strip().split("\t", 1)[0]
        if path == "/dev/null":
            continue
        normalized = path.replace("\\", "/")
        if normalized in FORBIDDEN_NAMES or normalized.startswith(FORBIDDEN_PREFIXES):
            raise ValueError(f"AI patch touches forbidden path: {normalized}")
        if normalized.startswith("/") or ".." in Path(normalized).parts:
            raise ValueError(f"AI patch contains unsafe path: {normalized}")
        if not normalized.startswith(ALLOWED_PREFIXES):
            raise ValueError(f"AI patch is outside allowed paths: {normalized}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--report", required=True)
    parser.add_argument("--diff", required=True)
    parser.add_argument("--output", required=True)
    args = parser.parse_args()

    api_key = os.environ.get("AI_API_KEY", "")
    base_url = os.environ.get("AI_BASE_URL", "")
    model = os.environ.get("AI_MODEL", "")
    if not all((api_key, base_url, model)):
        raise ValueError("AI_API_KEY, AI_BASE_URL and AI_MODEL are required")

    prompt = {
        "role": "user",
        "content": (
            "你是只读审查后的修复 Agent。根据校验报告和当前变更生成最小、可审计的修复补丁。"
            "只允许修改 data_assets/、requirements/、docs/、templates/ 或 checklists/ 下的文件；"
            "禁止修改 .github/、scripts/、hooks/、.git/、环境变量、密钥和权限配置。"
            "不要猜测业务规则；无法安全修复时返回 can_fix=false。"
            "必须只返回 JSON，不要 Markdown："
            '{"can_fix":true,"reason":"...","summary":"...","risk":"...",'
            '"patch":"完整 unified diff"}。'
            "patch 必须可由 git apply 应用；can_fix=false 时 patch 为空。\n\n"
            "校验报告:\n" + read_text(args.report) + "\n\n"
            "当前变更:\n" + read_text(args.diff)
        ),
    }
    payload = json.dumps(
        {"model": model, "messages": [prompt], "temperature": 0},
        ensure_ascii=False,
    ).encode("utf-8")
    request = urllib.request.Request(
        endpoint(base_url),
        data=payload,
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
        },
        method="POST",
    )

    try:
        with urllib.request.urlopen(request, timeout=120) as response:
            response_data = json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as exc:
        body = exc.read().decode("utf-8", errors="replace")[:2000]
        raise RuntimeError(f"AI service returned HTTP {exc.code}: {body}") from exc

    content = response_data["choices"][0]["message"]["content"]
    result = extract_json(content)
    if result.get("can_fix") is not True:
        raise RuntimeError(f"AI declined repair: {result.get('reason', 'no reason')}")
    patch = result.get("patch")
    if not isinstance(patch, str):
        raise ValueError("AI response patch must be a string")
    validate_patch(patch)

    output = Path(args.output)
    output.write_text(patch, encoding="utf-8")
    metadata = {
        "can_fix": True,
        "reason": str(result.get("reason", "")),
        "summary": str(result.get("summary", "")),
        "risk": str(result.get("risk", "")),
    }
    output.with_suffix(".json").write_text(
        json.dumps(metadata, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(json.dumps(metadata, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (ValueError, KeyError, RuntimeError, OSError) as exc:
        print(f"AI repair failed: {exc}", file=sys.stderr)
        raise SystemExit(1)
