# MARGO Scripts

Operational bootstrap helpers for **MARGO — Migration & Resource Governance Operator**.

## Contents

| Script | Purpose |
|---|---|
| `codex-login.sh` | Starts Codex CLI device-code authentication. |
| `margo-start.sh` | Bootstraps an observable MARGO session and launches the Phase 0 entry gate. |

## Authority

These scripts are subordinate to:

1. `AGENT_SPEC.md`
2. `IMPLEMENTATION_PLAN.md`
3. The versioned phase prompt under `prompts/`

They are not a second source of truth.

## Codex authentication

Run:

```bash
./scripts/codex-login.sh
```

The script starts:

```bash
codex login --device-auth
```

The browser/device-code interaction remains human-controlled.

The script never stores passwords, device codes, access tokens, or other credentials.

Verify with:

```bash
codex login status
```

## MARGO bootstrap

Run:

```bash
./scripts/margo-start.sh
```

The bootstrap displays eight observable transitions:

```text
[1/8] Environment
[2/8] Repository
[3/8] Authoritative documents
[4/8] Current phase instructions
[5/8] Repository safety baseline
[6/8] Governance
[7/8] MARGO entry gate
[8/8] Launch governed MARGO session
```

A unique runtime `Run ID` is displayed.

The Codex session is automatically given the governed initialization instruction, so the operator does not need to paste the prompt manually.

MARGO is instructed to announce internal transitions as:

```text
[MARGO STEP n] <STATE>
Action:
Evidence:
Result:
Next:
```

This observability is intentional and is part of the MARGO operating model.

## HITL-0 integrity

`margo-start.sh` can never grant HITL-0.

Human authorization MUST NOT be inferred from:

- script execution;
- prompt execution;
- previous authorization;
- conversational intent;
- silence or lack of objection;
- successful completion of a previous phase;
- automated state transitions.

The bootstrap may request, display, and carry authorization state, but only an explicit human decision can authorize Phase 0.

Development gate:

```text
BOOTSTRAP
    ↓
INSPECT
    ↓
UNDERSTAND
    ↓
HITL-0 REQUIRED
    ↓
WAIT FOR HUMAN
    ↓
[explicit Phase 0 authorization]
    ↓
Phase 0 execution
```

Operational gates remain separate:

```text
HITL #1 = COPY authorization
HITL #2 = VALIDATION ratification
HITL #3 = DELETE authorization
```

## Run ID

Each bootstrap session receives a unique runtime identifier.

The bootstrap does not create the persistent `runs/<run-id>/` evidence package by itself. Persistent evidence remains governed by the implementation plan and future evidence/state capabilities.

## Non-destructive boundary

Before HITL-0, MARGO must not:

- modify repository files;
- execute Discord API operations;
- create, update, move, rename, or delete Discord resources;
- implement formal HITL approval logic;
- introduce Discord credentials or secrets;
- proceed to later phases.

## Phase prompt

The canonical Phase 0 instruction is:

```text
prompts/phase-0-repository-foundation.md
```

`margo-start.sh` loads it automatically. The runtime wrapper adds session-specific context and observability requirements; it must not weaken authoritative governance.

## Maintenance

Script changes must preserve:

1. fail-closed behavior;
2. explicit human authorization;
3. separation of HITL-0 from operational HITL gates;
4. no credential persistence;
5. no Discord mutation during Phase 0;
6. observable state transitions;
7. authoritative-document precedence.

If a script conflicts with an authoritative document, the conflict must be reported and resolved deliberately.

## Setup

From the repository root:

```bash
chmod +x scripts/codex-login.sh
chmod +x scripts/margo-start.sh
```

Then:

```bash
./scripts/codex-login.sh
codex login status
./scripts/margo-start.sh
```
