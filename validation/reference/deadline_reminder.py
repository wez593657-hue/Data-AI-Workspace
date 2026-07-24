"""Reference implementation for the synthetic deadline reminder example."""

from __future__ import annotations

from datetime import date
from typing import Any


def evaluate(payload: dict[str, Any]) -> dict[str, Any]:
    """Return the expected business result without database access."""
    due_date = payload.get("due_date")
    current_date = payload.get("current_date")
    handle_status = payload.get("handle_status")
    if not due_date or not current_date:
        return {"remind_flag": "0", "overdue_days": 0}

    overdue_days = (date.fromisoformat(current_date) - date.fromisoformat(due_date)).days
    should_remind = overdue_days > 0 and handle_status != "1"
    return {
        "remind_flag": "1" if should_remind else "0",
        "overdue_days": overdue_days if should_remind else 0,
    }
