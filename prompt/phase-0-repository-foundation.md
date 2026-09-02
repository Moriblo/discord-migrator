# MARGO — Phase 0 Codex Execution Prompt

**Agent:** MARGO — Migration & Resource Governance Operator  
**Project:** `discord-migrator`  
**Phase:** 0 — Repository Foundation  
**Prompt Version:** 0.3  
**Status:** Ready for governed execution

---

## 1. Mandatory Phase 0 Entry Gate

Before modifying the repository, MARGO MUST:

1. read `AGENT_SPEC.md`;
2. read `IMPLEMENTATION_PLAN.md`;
3. read this prompt;
4. inspect the current repository state;
5. present a concise understanding of:
   - Phase 0 objective;
   - deliverables;
   - hard constraints;
   - planned actions;
   - prohibited actions;
   - stopping condition;
6. explicitly state that Phase 0 is non-destructive;
7. explicitly state that no Discord mutation will occur;
8. request explicit human authorization for Phase 0.

The authorization gate is:

**HITL-0 — Phase Execution Authorization**

Only an explicit approval for **Phase 0** may authorize implementation.

HITL-0 is distinct from:

- HITL #1 — COPY authorization;
- HITL #2 — VALIDATION ratification;
- HITL #3 — DELETE authorization.

No approval may be reused for another gate or another phase.

### Authorization must never be inferred

Do NOT infer HITL-0 from:

- execution of this script;
- execution of this prompt;
- conversational intent;
- silence or lack of objection;
- previous authorization;
- successful completion of another phase;
- automated state transitions.

If explicit authorization is not granted, STOP without modifying the repository.

---

## 2. Mandatory Transition Observability

MARGO MUST announce every material execution transition.

Use exactly this structure:

```text
[MARGO STEP n] <STATE>
Action: <what is being performed>
Evidence: <what was verified>
Result: <result>
Next: <next state>
```

Use sequential step numbers.

At minimum, announce:

1. `BOOTSTRAP_RECEIVED`
2. `REPOSITORY_INSPECTED`
3. `AUTHORITATIVE_DOCS_READ`
4. `PHASE_PROMPT_READ`
5. `PHASE_UNDERSTANDING`
6. `SAFETY_BOUNDARY_CONFIRMED`
7. `HITL0_GATE_REACHED`
8. `WAITING_FOR_HUMAN_AUTHORIZATION`

After explicit HITL-0 authorization, continue announcing material transitions through:

9. `HITL0_AUTHORIZED`
10. `PHASE0_IMPLEMENTATION_STARTED`
11. `PHASE0_IMPLEMENTATION_COMPLETED`
12. `TESTING_STARTED`
13. `TESTING_COMPLETED`
14. `PHASE0_REPORT_READY`
15. `PHASE0_STOPPED_FOR_HUMAN_REVIEW`

The transition announcements are for observability and auditability. They are not authorization mechanisms.

---

## 3. Authoritative Documents

Treat these as authoritative:

- `AGENT_SPEC.md`
- `IMPLEMENTATION_PLAN.md`

This prompt is the versioned execution instruction for Phase 0.

If this prompt conflicts with an authoritative document:

1. stop;
2. report the exact conflict;
3. do not silently resolve it;
4. wait for human direction.

---

## 4. Objective

Implement **only Phase 0 — Repository Foundation**.

Phase 0 establishes the engineering foundation for MARGO. It does not implement migration behavior.

---

## 5. Critical Safety Constraints

During Phase 0:

- Do NOT implement real Discord API integration.
- Do NOT create, update, move, rename, or delete any Discord resource.
- Do NOT implement source cleanup.
- Do NOT implement executable operational HITL approval logic.
- Do NOT introduce Discord credentials, tokens, or secrets.
- Do NOT hard-code `aval`, `Aplicações`, `Moacyr Blondet`, or other migration-specific identities into application logic.
- Do NOT implement later-phase behavior.
- Do NOT silently change architecture.
- Do NOT bypass the phase gate.
- Do NOT modify the repository before explicit HITL-0 authorization.

Phase 0 is fully non-destructive.

The existing `avalbot` / Pirate application is completely independent from this repository.

---

## 6. Phase 0 Deliverables

After HITL-0 authorization, create the minimum engineering foundation:

```text
discord-migrator/
├── agent/
│   ├── config/
│   ├── discord/
│   ├── discovery/
│   ├── planning/
│   ├── migration/
│   ├── validation/
│   ├── hitl/
│   ├── cleanup/
│   ├── state/
│   ├── audit/
│   └── reporting/
├── config/
│   ├── migration.example.json
│   └── README.md
├── prompts/
│   └── phase-0-repository-foundation.md
├── scripts/
│   ├── codex-login.sh
│   ├── margo-start.sh
│   └── README.md
├── runs/
│   └── .gitkeep
├── tests/
│   ├── unit/
│   ├── integration/
│   └── fixtures/
├── docs/
├── AGENT_SPEC.md
├── IMPLEMENTATION_PLAN.md
├── README.md
├── pyproject.toml
└── .gitignore
```

### Required engineering content

Create:

1. Python package initialization where required;
2. `pyproject.toml` with project metadata and pytest configuration;
3. minimal pytest test suite;
4. Python/Codespaces/secrets/runtime `.gitignore`;
5. `README.md` describing:
   - MARGO and project purpose;
   - current implementation status;
   - high-level architecture;
   - safety/governance principles;
   - current limitation: no Discord mutation capability;
   - how to install and run tests;
6. `config/migration.example.json` with placeholders only;
7. `config/README.md` explaining configuration, secrets, and execution policy;
8. basic package/module placeholders for the future architecture;
9. `runs/.gitkeep`;
10. test directories and fixtures structure;
11. `docs/` foundation if appropriate;
12. basic CI workflow that runs the Phase 0 test suite.

Keep the foundation minimal.

---

## 7. Configuration Example

The example may follow the conceptual model in `AGENT_SPEC.md`.

It MUST use placeholders such as:

```text
${SOURCE_SERVER_ID}
${SOURCE_CATEGORY_ID}
${DESTINATION_SERVER_ID}
```

It MUST NOT contain:

- credentials;
- tokens;
- webhook secrets;
- private operational values;
- real migration-specific IDs.

---

## 8. Tests

At minimum, tests must demonstrate:

- the Python package can be imported;
- pytest executes successfully;
- the Phase 0 foundation contains no active Discord mutation implementation;
- configuration examples contain no credentials/secrets.

The CI workflow must execute the same Phase 0 test suite.

Do not create artificial tests for functionality that belongs to later phases.

---

## 9. Dependencies

Use Python 3.11+ compatible syntax.

Use type hints where useful.

Prefer the smallest reasonable dependency set.

Do NOT add a Discord SDK dependency during Phase 0 unless it is strictly required by the foundation. Discord integration belongs to the dedicated discovery/integration phase.

---

## 10. Architecture Discipline

Maintain separation between:

- configuration;
- Discord integration;
- discovery;
- planning;
- migration;
- validation;
- HITL;
- state;
- audit/evidence;
- reporting;
- cleanup.

Package/module placeholders may exist so the architecture is visible, but they must contain no premature operational behavior.

Do not implement the formal HITL subsystem in Phase 0.

---

## 11. Git Hygiene

Before modifying anything:

1. inspect the repository;
2. identify existing files;
3. preserve authoritative specification documents;
4. avoid unnecessary files;
5. avoid overwriting existing work.

Do not assume the repository is empty.

Scripts under `scripts/` are operational helpers and must remain subordinate to the authoritative documents.

---

## 12. Phase 0 Exit Gate

After implementation:

1. run the complete Phase 0 test suite;
2. run/verify the basic CI workflow where feasible in the local environment;
3. report exact commands and results;
4. report the resulting relevant repository structure;
5. report all files created or modified;
6. report all deviations from:
   - `AGENT_SPEC.md`;
   - `IMPLEMENTATION_PLAN.md`;
   - this prompt;
7. explicitly confirm:
   - no Discord API mutation was implemented;
   - no Discord credentials were added;
   - no migration-specific identities were hard-coded;
   - no cleanup capability was implemented;
   - no formal operational HITL subsystem was implemented;
   - authoritative specifications were preserved;
8. announce `PHASE0_STOPPED_FOR_HUMAN_REVIEW`;
9. STOP.

Successful execution does NOT authorize Phase 1.

Do not proceed automatically to:

- Phase 1 — Configuration;
- Phase 2 — State Machine;
- Phase 3 — Manifest & Evidence;
- Discord discovery;
- dry-run execution;
- copy;
- validation;
- formal HITL implementation;
- cleanup.

---

## 13. Phase 0 Human Review

The final report must contain:

### A. Changes

Every relevant file created or modified.

### B. Repository Structure

Resulting relevant directory tree.

### C. Tests

- exact command;
- number of tests;
- pass/fail;
- warnings/failures.

### D. CI

- workflow created;
- command executed locally, if applicable;
- CI limitations, if any.

### E. Safety

Explicit confirmation of all Phase 0 safety constraints.

### F. Deviations

If none:

```text
No deviations identified.
```

### G. Recommendations

Report architectural concerns without implementing them automatically.

---

## 14. Definition of Phase 0 Completion

Phase 0 is complete only when:

- repository foundation exists;
- project installation works;
- pytest runs successfully;
- CI workflow exists and is valid;
- basic package structure exists;
- configuration example exists;
- no secrets are present;
- no Discord mutation capability exists;
- specification documents remain intact;
- implementation is consistent with the authoritative documents;
- result is ready for human review.

Successful code execution alone is not phase acceptance.

---

## 15. Guiding Principle

Development follows:

```text
Specification
      ↓
Implementation Plan
      ↓
Versioned Phase Prompt
      ↓
MARGO Inspection
      ↓
MARGO Understanding
      ↓
HITL-0
      ↓
Implementation
      ↓
Tests
      ↓
Report
      ↓
Human Review
      ↓
Phase Acceptance
      ↓
Next Phase
```

Do not collapse these steps into one autonomous implementation cycle.

---

## 16. Final Instruction

First, inspect and understand.

Then present the Phase 0 understanding and request **HITL-0**.

Do not modify anything before explicit authorization.

If authorized, implement **Phase 0 only**.

Implement minimally.

Test completely.

Report precisely.

Announce transitions.

Stop.

Wait for human review and phase acceptance before proceeding.
