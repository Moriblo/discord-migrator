# MARGO — Discord Migrator

**MARGO (Migration & Resource Governance Operator)** is a controlled, auditable Discord resource migration agent designed around Human-in-the-Loop (HITL) governance.

The project is intentionally built incrementally. Safety, authorization integrity, observability, and evidence take precedence over migration speed.

## Purpose

MARGO is designed to support controlled migration of Discord resources between servers while ensuring that:

- migration actions are explicitly authorized;
- destructive actions require a separate explicit authorization;
- every relevant transition is observable;
- execution produces auditable evidence;
- configuration is externalized rather than hard-coded;
- the system fails closed when authorization or required evidence is missing.

## Governance Model

MARGO has two distinct HITL mechanisms.

### Development HITL-0

**HITL-0** is the authorization gate for executing the **current development phase**.

It must be granted explicitly by a human after MARGO has:

1. inspected the repository;
2. read the authoritative project documents;
3. read the current phase prompt;
4. presented its understanding of the phase objective and constraints;
5. confirmed the safety boundary and stopping condition.

Authorization cannot be inferred from:

- launching a script;
- running a prompt;
- previous authorization;
- completion of a previous phase;
- conversational intent;
- silence or ambiguity;
- automated workflow transitions.

After completing the authorized phase, MARGO must stop and wait for human review and phase acceptance.

### Operational HITL Gates

Operational migration uses three independent authorization gates:

| Gate | Purpose |
|---|---|
| **HITL #1** | Authorize COPY |
| **HITL #2** | Ratify VALIDATION |
| **HITL #3** | Authorize DELETE |

An approval for one gate cannot be reused for another gate.

The first real end-to-end operational milestone intentionally stops after **HITL #2**. Source cleanup is a later capability requiring HITL #3.

## Development Flow

Every development phase follows:

```text
Inspect
  ↓
Understand
  ↓
HITL-0
  ↓
Implement current phase only
  ↓
Test
  ↓
Report
  ↓
Human Review
  ↓
Phase Acceptance
  ↓
Next Phase
```

MARGO must explicitly announce the relevant transitions during execution.

A standard transition record is:

```text
[MARGO STEP n] <STATE>
Action: <what is being performed>
Evidence: <what was verified>
Result: <result>
Next: <next state>
```

## Operational Flow

The first operational milestone follows:

```text
Discover
  ↓
Plan
  ↓
HITL #1 — COPY authorization
  ↓
Copy
  ↓
Validate
  ↓
HITL #2 — VALIDATION ratification
  ↓
STOP
```

Deletion is not part of this initial milestone.

## Implementation Phases

| Phase | Scope |
|---|---|
| **0** | Repository Foundation |
| **1** | Configuration |
| **2** | State Machine |
| **3** | Manifest & Evidence |
| **4** | Discord Discovery |
| **5** | Dry-Run Planning |
| **6** | Destination Copy |
| **7** | Validation |
| **8** | HITL Integration |
| **9** | Cleanup Authorization & Cleanup |
| **10** | End-to-End Testing & Hardening |

The authoritative implementation sequence is maintained in [`IMPLEMENTATION_PLAN.md`](IMPLEMENTATION_PLAN.md).

## Authoritative Documents

The project currently uses the following authority hierarchy:

1. [`AGENT_SPEC.md`](AGENT_SPEC.md) — agent behavior, governance, safety, and invariants.
2. [`IMPLEMENTATION_PLAN.md`](IMPLEMENTATION_PLAN.md) — phased implementation scope and acceptance criteria.
3. [`prompts/`](prompts/) — phase-specific execution instructions.
4. `README.md` and other supporting documentation — orientation and operational guidance.

If authoritative documents conflict, MARGO must **stop, report the conflict, and request human clarification**. It must not silently choose an interpretation or change the architecture.

## Phase 0 Safety Boundary

Phase 0 is deliberately non-destructive.

It must not:

- connect to Discord;
- call the Discord API;
- mutate Discord resources;
- delete or archive Discord resources;
- implement the operational HITL subsystem;
- introduce migration behavior from later phases;
- store secrets or credentials;
- hard-code the initial source/destination server, category, or channel identities.

Phase 0 establishes the repository foundation and development governance needed for later work.

## Configuration and Secrets

Discord server, category, and channel identities must be externally configured.

The initial operational scenario is conceptually:

```text
Source:      aval / Aplicações
Destination: Moacyr Blondet / Aplicações
```

These values are **scenario data, not application constants**, and must not be hard-coded into the implementation.

Secrets and credentials must never be committed to the repository.

## Evidence and Observability

MARGO is designed for auditable execution.

Operational evidence is persisted under:

```text
runs/<run-id>/
```

The **Run ID** is the correlation identifier for a governed execution.

Development bootstrap scripts may create a runtime Run ID for observability, but they must not fabricate HITL authorization or silently grant permission.

## Repository Structure

```text
discord-migrator/
├── AGENT_SPEC.md
├── IMPLEMENTATION_PLAN.md
├── README.md
├── prompts/
│   ├── README.md
│   └── phase-0-repository-foundation.md
├── scripts/
└── runs/
```

The structure will evolve as implementation phases are completed.

## Current Status

**Current development phase: Phase 0 — Repository Foundation**

Phase 0 must be explicitly authorized through HITL-0 before implementation begins.

The current phase is intentionally limited to repository foundation, development governance, documentation alignment, and the agreed non-destructive tooling.

## Security Principle

> Automation may prepare, observe, and execute an explicitly authorized development action, but it must never infer or manufacture the human authorization required to perform it.

## Getting Started

Before running any development automation:

1. Read [`AGENT_SPEC.md`](AGENT_SPEC.md).
2. Read [`IMPLEMENTATION_PLAN.md`](IMPLEMENTATION_PLAN.md).
3. Read the applicable phase prompt under [`prompts/`](prompts/).
4. Follow the phase entry gate.
5. Provide explicit HITL-0 authorization when requested.
6. Review the phase result before authorizing any subsequent phase.

See [`prompts/README.md`](prompts/README.md) for the prompt structure and execution rules.
