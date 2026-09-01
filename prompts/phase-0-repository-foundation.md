# MARGO — Phase 0 Codex Execution Prompt

**Agent:** MARGO — Migration & Resource Governance Operator  
**Project:** `discord-migrator`  
**Phase:** 0 — Repository Foundation  
**Status:** Ready for execution

## 1. Phase 0 entry gate — mandatory

Before modifying the repository, MARGO MUST:

1. Read:
   - `AGENT_SPEC.md`
   - `IMPLEMENTATION_PLAN.md`
   - `prompts/phase-0-repository-foundation.md`
2. Present a concise understanding of:
   - Phase 0 objective;
   - deliverables;
   - hard constraints;
   - planned actions;
   - prohibited actions;
   - stopping condition.
3. Explicitly state that Phase 0 is non-destructive and that no Discord mutation will occur.
4. Request an explicit human decision to execute Phase 0.

The execution gate is:

**HITL-0 — Phase Execution Authorization**

Only an explicit approval for Phase 0 may authorize implementation.

Silence, ambiguity, conversational intent, or approval given for another purpose MUST NOT be interpreted as authorization.

If authorization is not explicitly granted, MARGO MUST stop without modifying the repository.

HITL-0 is a development-governance gate and MUST NOT be confused with the operational migration gates defined in `AGENT_SPEC.md`:

- HITL #1 — COPY authorization
- HITL #2 — VALIDATION ratification
- HITL #3 — DELETE authorization

Do not implement the formal HITL subsystem in Phase 0. HITL-0 is a controlled execution checkpoint for this development phase.

---

## 2. Authoritative documents

Treat the following as authoritative:

- `AGENT_SPEC.md`
- `IMPLEMENTATION_PLAN.md`

If this prompt conflicts with either authoritative document, stop and report the conflict rather than silently changing the architecture.

---

## 3. Objective

Implement **only Phase 0 — Repository Foundation**.

MARGO is the agent being developed by this repository. Its eventual purpose is to perform controlled, auditable Discord resource migrations under explicit Human-in-the-Loop authorization.

Phase 0 establishes the engineering foundation only.

---

## 4. Critical safety constraints

At this phase:

- Do NOT implement real Discord API integration.
- Do NOT create, update, move, rename, or delete any Discord resource.
- Do NOT implement source cleanup.
- Do NOT implement executable HITL approval logic.
- Do NOT introduce Discord credentials, tokens, or secrets.
- Do NOT hard-code migration-specific identities such as `aval`, `Aplicações`, or `Moacyr Blondet`.
- Do NOT implement behavior belonging to later phases merely because it appears architecturally useful.
- Do NOT modify `AGENT_SPEC.md` or `IMPLEMENTATION_PLAN.md` unless explicitly instructed.
- Do NOT silently change architectural decisions.
- Do NOT make assumptions about future Discord behavior that belong to later implementation phases.

The existing `avalbot` / Pirate application is completely independent from this project.

Phase 0 must remain **fully non-destructive**.

---

## 5. Repository structure

The repository should evolve toward:

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

The human operator is responsible for adding the versioned Phase 0 prompt under `prompts/`.

The implementation structure, tests, configuration scaffolding, documentation, and engineering files are the responsibility of Codex.

Do not require the human operator to manually create the entire application tree.

---

## 6. Prompt versioning

Prompts used to implement MARGO are project artifacts and must be versioned.

The Phase 0 execution prompt is:

`prompts/phase-0-repository-foundation.md`

Do not create or use an untracked alternative prompt as the canonical Phase 0 instruction.

If implementation reveals that the prompt itself requires correction, report the issue instead of silently rewriting the prompt.

A future revised prompt should be explicitly versioned/committed as a deliberate project change.

Maintain traceability:

```text
Specification
     ↓
Implementation Plan
     ↓
Versioned Phase Prompt
     ↓
Codex Understanding
     ↓
HITL-0 Authorization
     ↓
Codex Implementation
     ↓
Tests / Review
     ↓
Phase Acceptance
```

---

## 7. Phase 0 deliverables

After HITL-0 authorization, implement the minimum foundation defined by `IMPLEMENTATION_PLAN.md`.

Create:

1. Python package initialization where required.
2. `pyproject.toml` with basic project metadata and pytest configuration.
3. Minimal pytest test suite.
4. Appropriate `.gitignore`.
5. `README.md` describing:
   - MARGO and the project purpose;
   - current implementation status;
   - high-level architecture;
   - safety and governance principles;
   - current limitation: no Discord mutation capability exists;
   - how to install/run tests.
6. `config/migration.example.json` using placeholders only.
7. `config/README.md` explaining:
   - configuration;
   - credentials/secrets;
   - execution policy.
8. Basic package/module placeholders for the future architecture.
9. `runs/.gitkeep`.
10. Initial test directories and fixtures structure.
11. `docs/` foundation if appropriate.

Keep the foundation minimal.

---

## 8. Configuration example

The example configuration may follow the conceptual model in `AGENT_SPEC.md`, but must not contain real identities or secrets.

Use placeholders such as:

```text
${SOURCE_SERVER_ID}
${SOURCE_CATEGORY_ID}
${DESTINATION_SERVER_ID}
```

No credential, token, webhook secret, or private operational value may appear in the example.

---

## 9. Tests

At minimum, create tests demonstrating that:

- the Python package can be imported;
- pytest executes successfully;
- the Phase 0 foundation contains no active Discord mutation implementation;
- configuration examples contain no credentials/secrets.

Tests should remain focused on Phase 0.

Do not create artificial tests for functionality that has not yet been implemented.

---

## 10. Dependencies

Use Python 3.11+ compatible syntax.

Use type hints where useful.

Prefer the smallest reasonable dependency set.

**Do not add a Discord SDK dependency during Phase 0** unless you can demonstrate that it is strictly required by the foundation. Discord integration belongs to the dedicated discovery/integration phase.

---

## 11. Architecture discipline

Maintain clear separation between:

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

Do not implement those future capabilities now.

It is acceptable to create package/module placeholders so the architecture is visible, but they must not contain premature operational behavior.

---

## 12. Git hygiene

Before modifying anything:

1. Inspect the current repository.
2. Identify files already present.
3. Preserve existing specification documents.
4. Avoid unnecessary files.
5. Avoid overwriting existing work.

Do not assume that the repository is empty.

---

## 13. Phase 0 exit gate

After implementation:

1. Run the complete test suite.
2. Produce the required implementation report.
3. STOP.

Successful execution does **not** authorize Phase 1.

MARGO MUST NOT automatically proceed to:

- Phase 1 — Configuration;
- Phase 2 — State Machine;
- Phase 3 — Manifest & Evidence;
- Discord discovery;
- dry-run execution;
- copy;
- validation;
- formal HITL implementation;
- cleanup.

The next phase requires explicit human review and authorization.

---

## 14. Phase acceptance / human review

After implementation, report:

### A. Changes

List every relevant file created or modified.

### B. Repository structure

Show the resulting relevant directory tree.

### C. Tests

Report:

- exact command executed;
- number of tests;
- pass/fail result;
- relevant warnings or failures.

### D. Safety

Explicitly confirm:

- no Discord API mutation was implemented;
- no Discord credentials were added;
- no migration-specific identities were hard-coded;
- no cleanup capability was implemented;
- no formal HITL approval subsystem was implemented;
- existing specifications were preserved.

### E. Deviations

List every deviation from `AGENT_SPEC.md`, `IMPLEMENTATION_PLAN.md`, or this prompt.

If there are none, explicitly state:

`No deviations identified.`

### F. Recommendations

If you identify an architectural concern that should be addressed before Phase 1, report it as a recommendation. Do not implement it automatically unless it belongs to Phase 0.

---

## 15. Definition of Phase 0 completion

Phase 0 is complete only when:

- repository foundation exists;
- project installation works;
- pytest runs successfully;
- basic package structure exists;
- configuration example exists;
- no secrets are present;
- no Discord mutation capability exists;
- specification documents remain intact;
- implementation is consistent with the authoritative documents;
- result is ready for human review.

Successful code execution alone is **not** approval to proceed.

---

## 16. Guiding principle

MARGO is being designed for **controlled autonomy**, not maximum autonomy.

During development, preserve the same principle:

```text
Specification
     ↓
Plan
     ↓
Explicit implementation scope
     ↓
Codex understanding
     ↓
HITL-0
     ↓
Codex execution
     ↓
Tests
     ↓
Human review
     ↓
Phase acceptance
     ↓
Next phase
```

Do not collapse these steps into a single autonomous implementation cycle.

---

## 17. Final instruction

First, inspect and understand.

Then present the Phase 0 understanding and request **HITL-0**.

Do not modify anything before explicit authorization.

If authorized, implement **Phase 0 only**.

Implement minimally.

Test completely.

Report precisely.

Stop.

Wait for human review before proceeding.
