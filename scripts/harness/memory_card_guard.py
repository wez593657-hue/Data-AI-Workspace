"""Version and existence checks for requirement rule memory cards."""

from __future__ import annotations

from pathlib import Path
from typing import Any

from .requirement_parser import RequirementError, extract_version


class MemoryCardError(ValueError):
    """Raised when a memory card cannot be verified."""


def find_memory_card(requirement: Path) -> Path | None:
    candidate = requirement.parent / f"{requirement.stem}规则记忆卡片.md"
    if candidate.is_file():
        return candidate
    candidates = sorted(requirement.parent.glob("*规则记忆卡片.md"))
    if len(candidates) == 1:
        return candidates[0]
    return None


def verify_memory_card(requirement: Path) -> dict[str, Any]:
    requirement_version = extract_version(requirement)
    card = find_memory_card(requirement)
    if card is None:
        raise MemoryCardError(f"未找到需求对应的规则记忆卡片: {requirement}")
    try:
        card_version = extract_version(card)
    except (OSError, RequirementError) as error:
        raise MemoryCardError(str(error)) from error
    if requirement_version != card_version:
        raise MemoryCardError(
            f"需求与记忆卡片版本不一致: requirement={requirement_version}, card={card_version}"
        )
    return {
        "requirement_file": str(requirement),
        "memory_card": str(card),
        "requirement_version": requirement_version,
        "memory_card_version": card_version,
        "result": "passed",
    }
