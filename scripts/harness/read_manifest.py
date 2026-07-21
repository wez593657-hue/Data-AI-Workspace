"""Read-order and required-file validation."""

from __future__ import annotations

from pathlib import Path
from typing import Any

import yaml


class ManifestError(ValueError):
    """Raised when a read manifest is incomplete or out of dependency order."""


DEFAULT_ORDER = {
    "project_rules": 0,
    "requirement": 1,
    "memory_card": 2,
    "ods_dictionary": 3,
    "ods_to_dwd_mapping": 4,
    "dwd_dictionary": 5,
    "dwd_to_dws_mapping": 6,
    "dws_dictionary": 7,
    "dws_to_ads_mapping": 8,
    "ads_dictionary": 9,
    "existing_implementation": 10,
}


def validate_manifest(path: Path, root: Path) -> dict[str, Any]:
    if not path.is_file():
        raise FileNotFoundError(f"读取清单不存在: {path}")
    payload = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    entries = payload.get("read_order")
    if not isinstance(entries, list) or not entries:
        raise ManifestError("read_manifest.yaml 必须包含非空 read_order 列表")
    missing: list[str] = []
    unknown: list[str] = []
    order_values: list[int] = []
    for entry in entries:
        if not isinstance(entry, dict):
            raise ManifestError("read_order 每项必须是对象")
        file_path = entry.get("path")
        purpose = entry.get("purpose")
        if not file_path or not purpose:
            raise ManifestError("读取清单每项必须包含 path 和 purpose")
        if entry.get("required", False) and not (root / file_path).is_file():
            missing.append(file_path)
        if purpose not in DEFAULT_ORDER:
            unknown.append(purpose)
        else:
            order_values.append(DEFAULT_ORDER[purpose])
    if missing:
        raise ManifestError(f"必需读取文件不存在: {missing}")
    if unknown:
        raise ManifestError(f"未知读取目的: {unknown}")
    if order_values != sorted(order_values):
        raise ManifestError("读取顺序违反数据依赖顺序")
    return {
        "manifest": str(path),
        "entry_count": len(entries),
        "result": "passed",
    }
