#!/usr/bin/env bash
set -euo pipefail

# MARGO / Codex authentication helper.
# Interactive device authentication is intentionally preserved.
# No passwords, device codes, tokens, or other credentials are stored.

echo
echo "============================================================"
echo " MARGO — Codex Device Authentication"
echo "============================================================"
echo
echo "[1/2] Starting Codex device authentication..."
echo "A browser step is required. Never share the device code."
echo

if ! command -v codex >/dev/null 2>&1; then
  echo "ERROR: 'codex' was not found on PATH." >&2
  exit 1
fi

codex login --device-auth

echo
echo "[2/2] Authentication command completed."
echo "Recommended verification:"
echo "  codex login status"
echo
echo "No credentials were written by this script."
