"""Phase 0 repository-foundation checks."""

from __future__ import annotations

import importlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def test_package_imports() -> None:
    """The empty package foundation is importable."""
    assert importlib.import_module("agent") is not None


def test_example_configuration_is_placeholder_only_and_secret_free() -> None:
    """The committed example contains no credentials or concrete resource IDs."""
    config_path = ROOT / "config" / "migration.example.json"
    config = json.loads(config_path.read_text(encoding="utf-8"))
    rendered = config_path.read_text(encoding="utf-8").lower()

    assert config["source"]["server_id"] == "${SOURCE_SERVER_ID}"
    assert config["source"]["category_id"] == "${SOURCE_CATEGORY_ID}"
    assert config["destination"]["server_id"] == "${DESTINATION_SERVER_ID}"
    assert "token" not in rendered
    assert "secret" not in rendered
    assert "webhook" not in rendered


def test_agent_foundation_has_no_operational_implementation() -> None:
    """Phase 0 package modules are documentation-only placeholders."""
    source_files = sorted((ROOT / "agent").rglob("*.py"))

    assert source_files
    for source_file in source_files:
        source = source_file.read_text(encoding="utf-8")
        assert source.lstrip().startswith('"""')
        assert "def " not in source
        assert "class " not in source
