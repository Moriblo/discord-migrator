# MARGO — Phase 0 Codex Execution Prompt

**Agent:** MARGO — Migration & Resource Governance Operator  
**Project:** `discord-migrator`  
**Phase:** 0 — Repository Foundation  
**Status:** Ready for execution

## 1. Authoritative documents

Before making any change, read:

- `AGENT_SPEC.md`
- `IMPLEMENTATION_PLAN.md`

These documents are authoritative.

If this prompt conflicts with either authoritative document, stop and report the conflict rather than silently changing the architecture.

## 2. Objective

Implement **only Phase 0 — Repository Foundation**.

MARGO is the agent being developed by this repository. Its eventual purpose is to perform controlled, auditable Discord resource migrations under explicit Human-in-the-Loop authorization.

Phase 0 establishes the engineering foundation only.

## 3. Critical safety constraints

At this phase:

- Do NOT implement real Discord API integration.
- Do NOT create, update, move, rename, or delete any Discord resource.
- Do NOT implement source cleanup.
- Do NOT implement executable HITL approval logic.
- Do NOT introduce Discord credentials, tokens, or secrets.
- Do NOT hard-code migration-specific identities such as `aval`, `Aplicações`, or `Moacyr Blondet`.
- Do NOT implement behavior belonging to later phases merely because it appears architecturally useful.
- Do NOT modify the existing `AGENT_SPEC.md` or `IMPLEMENTATION_PLAN.md` unless explicitly instructed.
- Do NOT silently change architectural decisions.
- Do NOT make assumptions about future Discord behavior that belong to later implementation phases.

The existing `avalbot` / Pirate application is completely independent from this project.

Phase 0 must remain **fully non-destructive**.

## 4. Repository structure

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

## 5. Prompt versioning

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
Codex Implementation
     ↓
Tests / Review
     ↓
Phase Acceptance
```

## 6. Phase 0 deliverables

Implement the minimum foundation defined by `IMPLEMENTATION_PLAN.md`.

Create:

1. Python package initialization where required.
2. `pyproject.toml` with basic project metadata and pytest configuration.
3. Minimal pytest test suite.
4. Appropriate `.gitignore`.
5. `README.md` describing MARGO, purpose, status, architecture, safety/governance principles, current limitation (no Discord mutation capability), and how to install/run tests.
6. `config/migration.example.json` using placeholders only.
7. `config/README.md` explaining configuration, credentials/secrets, and execution policy.
8. Basic package/module placeholders for the future architecture.
9. `runs/.gitkeep`.
10. Initial test directories and fixtures structure.
11. `docs/` foundation if appropriate.

Keep the foundation minimal.

## 7. Configuration example

The example configuration may follow the conceptual model in `AGENT_SPEC.md`, but must not contain real identities or secrets.

Use placeholders such as:

```text
${SOURCE_SERVER_ID}
${SOURCE_CATEGORY_ID}
${DESTINATION_SERVER_ID}
```

No credential, token, webhook secret, or private operational value may appear in the example.

## 8. Tests

At minimum, create tests demonstrating that:

- the Python package can be imported;
- pytest executes successfully;
- the Phase 0 foundation contains no active Discord mutation implementation;
- configuration examples contain no credentials/secrets.

Tests should remain focused on Phase 0.

Do not create artificial tests for functionality that has not yet been implemented.

## 9. Dependencies

Use Python 3.11+ compatible syntax.

Use type hints where useful.

Prefer the smallest reasonable dependency set.

**Do not add a Discord SDK dependency during Phase 0** unless you can demonstrate that it is strictly required by the foundation. Discord integration belongs to the dedicated discovery/integration phase.

## 10. Architecture discipline

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

## 11. Git hygiene

Before modifying anything:

1. Inspect the current repository.
2. Identify files already present.
3. Preserve existing specification documents.
4. Avoid unnecessary files.
5. Avoid overwriting existing work.

Do not assume that the repository is empty.

## 12. Phase boundary

This is a hard boundary.

After completing Phase 0:

**STOP.**

Do not automatically proceed to Phase 1 or any later capability, including Discord discovery, dry-run execution, copy, validation, HITL implementation, or cleanup.

The next phase requires an explicit decision after human review.

## 13. Phase acceptance / human review

Codex must not declare the overall project ready or advance the project to the next phase.

After implementation, report:

### A. Changes
List every relevant file created or modified.

### B. Repository structure
Show the resulting relevant directory tree.

### C. Tests
Report the exact command executed, number of tests, pass/fail result, and relevant warnings or failures.

### D. Safety
Explicitly confirm:

- no Discord API mutation was implemented;
- no Discord credentials were added;
- no migration-specific identities were hard-coded;
- no cleanup capability was implemented;
- no HITL approval was inferred or implemented;
- existing specifications were preserved.

### E. Deviations
List every deviation from `AGENT_SPEC.md`, `IMPLEMENTATION_PLAN.md`, or this prompt.

If there are none, explicitly state:

`No deviations identified.`

### F. Recommendations
If you identify an architectural concern that should be addressed before Phase 1, report it as a recommendation. Do not implement it automatically unless it belongs to Phase 0.

## 14. Definition of Phase 0 completion

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

## 15. Guiding principle

MARGO is being designed for **controlled autonomy**, not maximum autonomy.

During development, preserve the same principle:

```text
Specification
     ↓
Plan
     ↓
Explicit implementation scope
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

## 16. Final instruction

Implement **Phase 0 only**.

Inspect first.

Implement minimally.

Test completely.

Report precisely.

Stop.

Wait for human review before proceeding.
