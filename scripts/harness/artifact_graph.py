"""Build a conservative artifact graph from explicit Mapping relationships."""

from __future__ import annotations

from typing import Any


def build_artifact_graph(mappings: list[dict[str, Any]], unresolved: list[dict[str, Any]]) -> dict[str, Any]:
    nodes: set[str] = set()
    edges: list[dict[str, str]] = []
    for mapping in mappings:
        target = mapping.get("target_table", "")
        source = mapping.get("source_table", "")
        target_field = mapping.get("target_field", "")
        source_field = mapping.get("source_field", "")
        if not target:
            continue
        target_node = f"table:{target}#field:{target_field}"
        nodes.add(target_node)
        if source and source not in {"-", "UNRESOLVED"} and source_field and source_field not in {"-", "UNRESOLVED"}:
            source_node = f"table:{source}#field:{source_field}"
            nodes.add(source_node)
            edges.append({"from": source_node, "to": target_node, "rule": mapping.get("rule", ""), "source_path": mapping.get("source_path", "")})
    return {"schema_version": "0.1", "status": "blocked" if unresolved else "passed", "nodes": sorted(nodes), "edges": edges, "unresolved_count": len(unresolved)}
