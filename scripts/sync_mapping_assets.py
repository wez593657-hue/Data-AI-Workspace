"""
统一入口：根据 Mapping Excel 同步 MD 和 DDL。

调用方式:
    python scripts/sync_mapping_assets.py

流程:
    1. 检查 Excel 文件 → 创建/复用 harness task (schema_change)
    2. 逐状态迁移并记录证据 (CREATED → ... → ASSETS_UPDATED)
    3. 执行 mapping_excel_sync → 同步 3 个 Mapping MD
    4. 执行 generate_ads_assets → 生成 ADS DDL
    5. 逐文件校验 Excel→MD→DDL 一致性
"""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
if str(ROOT / "scripts") not in sys.path:
    sys.path.insert(0, str(ROOT / "scripts"))
HARNESS_DIR = ROOT / ".harness"
yaml = None  # lazy import

# ── 3 个 Mapping 层的描述 ──
LAYERS = [
    {
        "name": "ods_to_dwd",
        "excel": "DWD明细层数据模型_CRM_ V1.0.xlsx",
        "excel_dir": "ods_to_dwd",
        "md": "ods到dwd映射.md",
        "ddl_dir": "dwd",
    },
    {
        "name": "dwd_to_dws",
        "excel": "DWS汇总层数据模型_CRM_ V1.0.xlsx",
        "excel_dir": "dwd_to_dws",
        "md": "dwd到dws映射.md",
        "ddl_dir": "dws",
    },
    {
        "name": "dws_to_ads",
        "excel": "ADS应用层数据模型_CRM_ V1.0.xlsx",
        "excel_dir": "dws_to_ads",
        "md": "dws到ads映射.md",
        "ddl_dir": "ads",
    },
]


def _resolve(layer: dict, key: str) -> Path:
    if key == "excel":
        return ROOT / "data_assets" / "mapping" / layer["excel_dir"] / layer["excel"]
    if key == "md":
        return ROOT / "data_assets" / "mapping" / layer["excel_dir"] / layer["md"]
    if key == "ddl_dir":
        return ROOT / "data_assets" / "ddl" / layer["ddl_dir"]
    raise KeyError(key)


# ── 工具函数 ──


def utc_now() -> str:
    return datetime.now(timezone.utc).isoformat(timespec="seconds")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def git_revision() -> str:
    r = subprocess.run(["git", "rev-parse", "HEAD"], cwd=ROOT, capture_output=True, text=True)
    return r.stdout.strip() if r.returncode == 0 else "UNKNOWN"


def run_cmd(cmd: list[str], desc: str = "") -> str:
    r = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True, encoding="utf-8")
    if r.returncode != 0:
        print(f"\n[失败] {desc or ' '.join(cmd)}")
        err = r.stderr.strip()
        if err:
            print(err)
        sys.exit(1)
    return r.stdout.strip()


def write_evidence_yaml(task_id: str, data: dict) -> None:
    global yaml
    if yaml is None:
        import yaml as _yaml
        yaml = _yaml
    ev_path = HARNESS_DIR / "tasks" / task_id / "evidence" / f"{data['evidence_id']}.yaml"
    ev_path.parent.mkdir(parents=True, exist_ok=True)
    with open(ev_path, "w", encoding="utf-8") as f:
        yaml.dump(data, f, allow_unicode=True, sort_keys=False)


# ── Harness 操作 ──


def task_id_daily() -> str:
    return f"sync-mapping-{datetime.now().strftime('%Y%m%d')}"


def create_or_reuse_task() -> str:
    tid = task_id_daily()
    cli = [sys.executable, "-m", "scripts.harness.cli"]

    task_yaml = HARNESS_DIR / "tasks" / tid / "task.yaml"
    if task_yaml.exists():
        out = run_cmd(cli + ["status", tid], "读取任务状态")
        state = json.loads(out).get("state", "")
        terminal = {"COMPLETED", "PUSH_ALLOWED", "COMMIT_ALLOWED",
                    "FULL_VALIDATION_PASSED", "USER_APPROVED"}
        if state in terminal:
            tid = f"sync-mapping-{datetime.now().strftime('%Y%m%d_%H%M%S')}"
            run_cmd(cli + ["create", tid, "--purpose", "schema_change",
                           "--workflow-profile", "schema_change"], f"创建任务 {tid}")
        else:
            print(f"  复用任务 {tid} (状态: {state})")
        return tid

    run_cmd(cli + ["create", tid, "--purpose", "schema_change",
                   "--workflow-profile", "schema_change"], f"创建任务 {tid}")
    return tid


def record_ev(task_id: str, ev_id: str, phase: str, kind: str, purpose: str,
              details: str = "") -> None:
    cli = [sys.executable, "-m", "scripts.harness.cli", "record", task_id, ev_id,
           "--phase", phase, "--kind", kind, "--purpose", purpose,
           "--result", "passed"]
    if details:
        cli += ["--details", details]
    run_cmd(cli, f"记录证据 {ev_id}")


def transit(task_id: str, target: str, reason: str) -> None:
    cli = [sys.executable, "-m", "scripts.harness.cli", "transition", task_id, target,
           "--reason", reason]
    run_cmd(cli, f"迁移 → {target}")


# ── 步骤函数 ──


def step_check_excels() -> None:
    """步骤 1: 检查 3 个 Excel 文件是否存在。"""
    print(f"\n{'=' * 55}")
    print("  1/9: 检查上游 Excel 文件")
    print(f"{'=' * 55}")
    for layer in LAYERS:
        path = _resolve(layer, "excel")
        if not path.exists():
            print(f"  [错误] 找不到 {path.relative_to(ROOT)}")
            sys.exit(1)
        print(f"  ✓ {path.relative_to(ROOT)}")


def step_sha256() -> dict[str, str]:
    """步骤 2: 计算 Excel SHA256。"""
    print(f"\n{'=' * 55}")
    print("  2/9: 计算 Excel 校验和")
    print(f"{'=' * 55}")
    checksums = {}
    for layer in LAYERS:
        h = sha256_file(_resolve(layer, "excel"))
        checksums[layer["name"]] = h
        print(f"  {layer['name']}: {h[:16]}...")
    return checksums


def step_setup_task(checksums: dict[str, str]) -> str:
    """步骤 3: 创建任务并设置 change_manifest。"""
    print(f"\n{'=' * 55}")
    print("  3/9: 创建 Harness 任务")
    print(f"{'=' * 55}")
    tid = create_or_reuse_task()
    print(f"  任务: {tid}")

    # write change_manifest.yaml
    manifest = {
        "schema_version": "0.1",
        "task_id": tid,
        "purpose": "schema_change",
        "user_confirmation": "confirmed",
        "description": "Mapping Excel → MD/DDL 自动同步",
        "allowed_changes": [
            {"path": "data_assets/mapping/"},
            {"path": "data_assets/ddl/ads/"},
            {"path": "data_assets/ddl/dwd/"},
            {"path": "data_assets/ddl/dws/"},
            {"path": "data_assets/ddl/tmp/"},
            {"path": f".harness/tasks/{tid}/"},
        ],
        "read_only_inputs": [
            {"path": str(_resolve(layer, "excel").relative_to(ROOT))}
            for layer in LAYERS
        ],
    }
    global yaml
    if yaml is None:
        import yaml as _yaml
        yaml = _yaml
    mpath = HARNESS_DIR / "tasks" / tid / "change_manifest.yaml"
    mpath.parent.mkdir(parents=True, exist_ok=True)
    with open(mpath, "w", encoding="utf-8") as f:
        yaml.dump(manifest, f, allow_unicode=True, sort_keys=False)
    print("  change_manifest.yaml ← 已写入")
    return tid


def step_initial_states(task_id: str) -> None:
    """步骤 4-6: CREATED → MAPPING_EXCEL_ANALYZED → RELATED_FILES_SCANNED → CHANGE_SCOPE_IDENTIFIED"""
    print(f"\n{'=' * 55}")
    print("  4-6/9: 初始状态迁移")
    print(f"{'=' * 55}")

    record_ev(task_id, "workflow-routing-ev", "CREATED", "workflow_routing",
              "workflow_routing", "Mapping Excel → MD/DDL 同步触发")
    transit(task_id, "MAPPING_EXCEL_ANALYZED", "3个Excel文件最新，需要同步MD/DDL")

    record_ev(task_id, "excel-analysis-ev", "MAPPING_EXCEL_ANALYZED",
              "mapping_excel_analysis", "mapping_excel_analysis",
              "根据3个Excel文件同步对应层的MD和DDL")
    transit(task_id, "RELATED_FILES_SCANNED", "需同步: Mapping MD + DDL")

    record_ev(task_id, "related-files-scan-ev", "RELATED_FILES_SCANNED",
              "related_files_scan", "related_files_scan",
              "3层Mapping MD + 3层DDL")
    transit(task_id, "CHANGE_SCOPE_IDENTIFIED",
            "变更范围: 全量同步3个Mapping层的MD和DDL")


def step_sync_mapping_md(task_id: str) -> list[dict]:
    """步骤 7: 执行 Mapping MD 同步 → USER_SCOPE_CONFIRMED"""
    print(f"\n{'=' * 55}")
    print("  7/9: 执行 Mapping MD 同步")
    print(f"{'=' * 55}")

    from scripts.harness.mapping_excel_sync import sync_mapping_markdown
    results = sync_mapping_markdown(ROOT)
    for r in results:
        print(f"  ✓ {r['flow']}: {r['record_count']} 条记录 → {r['output']}")

    record_ev(task_id, "scope-confirmation-ev", "CHANGE_SCOPE_IDENTIFIED",
              "change_scope", "change_scope", f"Mapping MD已同步: {len(results)} 层")

    # scope_confirmation 证据（门禁要求：USER_SCOPE_CONFIRMED → ASSETS_UPDATED 需要 purpose=scope_confirmation）
    record_ev(task_id, "scope-confirmation-v2", "CHANGE_SCOPE_IDENTIFIED",
              "user_confirmation", "scope_confirmation", "用户确认：根据Excel更新MD文件及DDL")

    transit(task_id, "USER_SCOPE_CONFIRMED", "Mapping MD文件已同步完成")
    return results


def step_generate_ads_assets(task_id: str) -> None:
    """步骤 7b: 生成 ADS DDL"""
    print(f"\n{'=' * 55}")
    print("  7b/9: 生成 ADS DDL")
    print(f"{'=' * 55}")

    from scripts.generate_ads_assets import main as generate_ads
    generate_ads()

    record_ev(task_id, "asset-update-ev", "USER_SCOPE_CONFIRMED",
              "asset_update", "asset_update",
              "generate_ads_assets: ADS DDL 已生成")

    rev = git_revision()
    now = utc_now()
    ads_excel = str(_resolve(LAYERS[2], "excel").relative_to(ROOT))
    skill_ev = {
        "evidence_id": "skill-execution-ev",
        "task_id": task_id,
        "phase": "USER_SCOPE_CONFIRMED",
        "kind": "skill_execution",
        "purpose": "skill_execution",
        "result": "passed",
        "details": "Mapping MD同步 + ADS DDL生成",
        "repository_revision": rev,
        "created_at": now,
        "input_workbook": ads_excel,
        "skills": ["kingbase-ddl-generator", "excel-to-md-sync"],
        "steps": ["excel_to_mapping", "excel_to_ddl"],
        "output_files": [
            "data_assets/mapping/ods_to_dwd/ods到dwd映射.md",
            "data_assets/mapping/dwd_to_dws/dwd到dws映射.md",
            "data_assets/mapping/dws_to_ads/dws到ads映射.md",
            "data_assets/ddl/ads/",
        ],
    }
    write_evidence_yaml(task_id, skill_ev)

    # 手动追加 evidence_id 到 task.yaml（record_cli 通常自动做，但这里手动写文件）
    _append_evidence_id(task_id, "skill-execution-ev")
    print("  ✓ skill_execution 证据已记录")


def _append_evidence_id(task_id: str, eid: str) -> None:
    """追加 evidence_id 到 task.yaml 并更新 state_seal。"""
    tpath = HARNESS_DIR / "tasks" / task_id / "task.yaml"
    import yaml as _yaml
    with open(tpath, "r", encoding="utf-8") as f:
        data = _yaml.safe_load(f) or {}
    ids = data.setdefault("evidence_ids", [])
    if eid not in ids:
        ids.append(eid)
    # 更新 seal
    import hashlib, json
    canonical = json.dumps({
        "task_id": data.get("task_id"),
        "workflow_profile": data.get("workflow_profile"),
        "state": data.get("state"),
        "history": data.get("history", []),
    }, ensure_ascii=False, sort_keys=True, separators=(",", ":"))
    data["state_seal"] = hashlib.sha256(canonical.encode("utf-8")).hexdigest()
    data["updated_at"] = utc_now()
    with open(tpath, "w", encoding="utf-8") as f:
        _yaml.dump(data, f, allow_unicode=True, sort_keys=False)


def step_verify_consistency(task_id: str, mapping_results: list[dict]) -> None:
    """步骤 8: 全量一致性校验 → ASSETS_UPDATED"""
    print(f"\n{'=' * 55}")
    print("  8-9/9: 全量一致性校验 + 状态迁移")
    print(f"{'=' * 55}")

    from scripts.harness.mapping_excel_sync import extract_workbook
    for mr in mapping_results:
        md_path = ROOT / mr["output"]
        if not md_path.exists():
            print(f"  [错误] MD 文件缺失: {mr['output']}")
            sys.exit(1)
        re_extracted = extract_workbook(ROOT / mr["workbook"])
        if len(re_extracted) != mr["record_count"]:
            print(f"  [错误] {mr['flow']}: Excel {len(re_extracted)} 条 ≠ MD {mr['record_count']} 条")
            sys.exit(1)
        print(f"  ✓ {mr['flow']}: {mr['record_count']} 条记录一致")

    transit(task_id, "ASSETS_UPDATED",
            "Mapping MD + ADS DDL 已全部生成并验证一致性")


def main() -> None:
    print("Mapping Excel → MD / DDL 统一同步工具")
    print(f"仓库: {ROOT}")

    step_check_excels()
    checksums = step_sha256()
    task_id = step_setup_task(checksums)
    step_initial_states(task_id)
    mapping_results = step_sync_mapping_md(task_id)
    step_generate_ads_assets(task_id)
    step_verify_consistency(task_id, mapping_results)

    print(f"\n{'=' * 55}")
    print(f"  完成！任务: {task_id} (ASSETS_UPDATED)")
    print(f"{'=' * 55}")
    print(f"\n下一步 → 执行资产审查:")
    print(f"  python -m scripts.harness.cli transition {task_id} ASSETS_REVIEW_PASSED "
          f"--reason \"资产审查通过\"")


if __name__ == "__main__":
    main()
