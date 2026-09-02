#!/usr/bin/env bash
set -euo pipefail

# MARGO bootstrap / entry protocol.
# This script can request/display authorization state, but can NEVER grant HITL-0.

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

RUN_ID="$(date -u +"%Y%m%dT%H%M%SZ")-$(od -An -N2 -tu2 /dev/urandom | tr -d ' ' | awk '{printf "%04x", $1}')"

step() {
  echo
  echo "[$1/8] $2"
}

echo
echo "============================================================"
echo " MARGO — Migration & Resource Governance Operator"
echo " Bootstrap / Entry Protocol"
echo "============================================================"
echo
echo "Run ID:        ${RUN_ID}"
echo "Repository:    discord-migrator"
echo "Path:          ${REPO_ROOT}"
echo "Authorization: NONE"
echo "Mode:          GOVERNED / NON-DESTRUCTIVE ENTRY"
echo
echo "Invariant: this script cannot grant HITL-0."
echo

step 1 "Environment"
command -v codex >/dev/null 2>&1 || { echo "ERROR: Codex CLI not found." >&2; exit 1; }
echo "       STATUS: OK"

step 2 "Repository"
git rev-parse --show-toplevel >/dev/null 2>&1 || { echo "ERROR: not a Git repository." >&2; exit 1; }
echo "       Branch: ${BRANCH:-$(git branch --show-current)}"
echo "       STATUS: OK"

step 3 "Authoritative documents"
for f in AGENT_SPEC.md IMPLEMENTATION_PLAN.md; do
  [[ -f "$f" ]] || { echo "ERROR: missing $f" >&2; exit 1; }
done
echo "       STATUS: OK"

step 4 "Current phase instructions"
PHASE_PROMPT="prompt/phase-0-repository-foundation.md"
[[ -f "${PHASE_PROMPT}" ]] || { echo "ERROR: missing ${PHASE_PROMPT}" >&2; exit 1; }
echo "       STATUS: OK"

step 5 "Repository safety baseline"
if [[ -n "$(git status --porcelain)" ]]; then
  echo "       Working tree: NOT CLEAN"
  git status --short
else
  echo "       Working tree: CLEAN"
fi
echo "       Repository mutation before HITL-0: PROHIBITED"
echo "       Discord mutation: PROHIBITED"
echo "       STATUS: OK"

step 6 "Governance"
echo "       HITL-0: REQUIRED"
echo "       Operational HITL #1/#2/#3: PRESERVED"
echo "       Authorization inference: PROHIBITED"
echo "       STATUS: OK"

step 7 "MARGO entry gate"
echo "       Read authoritative documents and Phase 0 prompt."
echo "       Present understanding, then STOP and request HITL-0."
echo "       STATUS: WAITING"

step 8 "Launch governed MARGO session"
echo "       Stage: ENTRY_GATE"
echo "       Authorization: HITL-0 REQUIRED"
echo
echo "------------------------------------------------------------"
echo " MARGO HANDOFF — automatic; no prompt paste required"
echo "------------------------------------------------------------"

RUNTIME_PROMPT=$(cat <<EOF
You are MARGO — Migration & Resource Governance Operator.

MARGO RUN CONTEXT
- Run ID: ${RUN_ID}
- Repository: discord-migrator
- Current phase: Phase 0 — Repository Foundation
- Current stage: ENTRY_GATE
- Authorization state: HITL-0 REQUIRED

Read and strictly follow:
- AGENT_SPEC.md
- IMPLEMENTATION_PLAN.md
- ${PHASE_PROMPT}

This bootstrap instruction is NOT HITL-0 authorization.

Perform ONLY the mandatory Phase 0 entry gate.
Do not modify, create, delete, rename, or commit repository files.
Do not execute Discord API operations.
Do not implement anything.
Do not proceed beyond the entry gate.

For observability, announce every transition using:
[MARGO STEP n] <STATE>
Action: <what is being performed>
Evidence: <what was verified, when applicable>
Result: <result>
Next: <next state>

Use sequential step numbers and do not skip transitions.

At minimum report:
1. BOOTSTRAP_RECEIVED
2. AUTHORITATIVE_DOCS_READ
3. PHASE_PROMPT_READ
4. PHASE_UNDERSTANDING
5. SAFETY_BOUNDARY_CONFIRMED
6. HITL0_GATE_REACHED
7. WAITING_FOR_HUMAN_AUTHORIZATION

At HITL0_GATE_REACHED explicitly state:
- Phase 0 is non-destructive.
- No Discord resources will be mutated.
- No repository changes have been authorized.
- HITL-0 is distinct from operational HITL #1/#2/#3.
- This bootstrap instruction itself is not authorization.

Do not infer authorization from:
- script execution;
- prompt execution;
- previous authorization;
- conversational intent;
- silence or lack of objection;
- successful completion of a previous phase;
- automated state transitions.

Then STOP and request explicit human authorization for Phase 0.
EOF
)

exec codex "${RUNTIME_PROMPT}"
