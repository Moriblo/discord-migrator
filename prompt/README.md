# MARGO Prompts

This directory contains the phase-specific execution prompts used to govern MARGO's development process.

The prompts are **instructions for controlled execution**, not substitutes for the authoritative project specification or implementation plan.

## Authority

The governing document hierarchy is:

1. [`../AGENT_SPEC.md`](../AGENT_SPEC.md)
2. [`../IMPLEMENTATION_PLAN.md`](../IMPLEMENTATION_PLAN.md)
3. Phase-specific prompts in this directory
4. Supporting documentation

If a prompt conflicts with an authoritative document, MARGO must stop and report the conflict. It must not silently resolve the inconsistency.

## Development HITL-0

Every phase prompt is subject to the development authorization gate **HITL-0**.

Before implementing a phase, MARGO must:

1. inspect the repository;
2. read `AGENT_SPEC.md`;
3. read `IMPLEMENTATION_PLAN.md`;
4. read the current phase prompt;
5. summarize the phase objective, deliverables, constraints, prohibited actions, and stopping condition;
6. explicitly state the safety boundary;
7. request explicit human authorization.

MARGO must not interpret the following as authorization:

- opening or executing a prompt;
- launching a bootstrap script;
- conversational intent;
- silence;
- ambiguous language;
- a previous HITL-0 approval;
- approval of another phase;
- completion of an earlier phase.

HITL-0 authorizes **only the current development phase**.

## Execution and Observability

Phase execution follows:

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

MARGO should make each meaningful transition explicit using:

```text
[MARGO STEP n] <STATE>
Action: <what is being performed>
Evidence: <what was verified>
Result: <result>
Next: <next state>
```

The execution Run ID should be used as the correlation identifier for governed work.

## Prompt Inventory

### `phase-0-repository-foundation.md`

Defines the controlled entry and execution procedure for **Phase 0 — Repository Foundation**.

Phase 0 is non-destructive. It establishes the repository foundation and development governance without connecting to Discord or mutating Discord resources.

The Phase 0 prompt is aligned with the current implementation plan and includes the required HITL-0 entry gate, transition observability, implementation boundary, testing, reporting, and human-review stopping condition.

## Operational HITL vs. Development HITL

Do not confuse development HITL-0 with operational migration authorization.

| Mechanism | Scope |
|---|---|
| **HITL-0** | Authorizes implementation of the current development phase |
| **HITL #1** | Authorizes operational COPY |
| **HITL #2** | Ratifies operational VALIDATION |
| **HITL #3** | Authorizes operational DELETE |

These authorizations are independent and cannot be reused across gates.

## Adding a New Phase Prompt

When adding a new phase prompt:

1. Follow the phase numbering defined in `IMPLEMENTATION_PLAN.md`.
2. State the exact phase objective.
3. Identify required inputs and authoritative references.
4. Define the HITL-0 entry gate.
5. Define permitted implementation scope.
6. Define prohibited actions.
7. Define testing requirements.
8. Define the reporting requirements.
9. Define the stopping condition.
10. Keep the prompt consistent with `AGENT_SPEC.md` and `IMPLEMENTATION_PLAN.md`.

Do not introduce new architecture, permissions, migration behavior, or governance rules solely through a phase prompt without aligning the authoritative documents first.

## Current Status

The current prompt inventory begins with:

```text
prompt/
├── README.md
└── phase-0-repository-foundation.md
```

As new phases are approved and implemented, their prompts should be added here and reflected in the implementation plan.

## Maintenance Rule

Documentation changes that affect governance, authorization, safety boundaries, phase scope, or architecture must be reviewed for consistency across:

- `AGENT_SPEC.md`
- `IMPLEMENTATION_PLAN.md`
- the affected phase prompt(s)
- relevant repository documentation

If consistency cannot be established, stop and request human clarification.
