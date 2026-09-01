# Discord Migrator — Implementation Plan

**Repository:** `moriblo/discord-migrator`  
**Product:** Discord Migrator — Human-Governed Migration Agent  
**Agent:** **MARGO — Migration & Resource Governance Operator**  
**Specification:** `AGENT_SPEC.md`  
**Status:** Implementation planning  
**Version:** 0.2

## 1. Implementation Objective

Build the Discord Migrator incrementally, beginning with a fully non-destructive implementation and enabling cleanup only after discovery, copy, validation, and HITL controls have been demonstrated to work.

Core operational governance model:

- **HITL #1:** authorization to COPY
- **HITL #2:** ratification of VALIDATION
- **HITL #3:** authorization to DELETE

No operational approval may be reused for a different gate.

Development itself also follows a governance checkpoint:

- **HITL-0:** authorization to execute a development phase

HITL-0 is a development gate and is distinct from the three operational migration gates.

## 2. Implementation Strategy

Phases:

0. Repository Foundation
1. Configuration
2. State Machine
3. Manifest & Evidence
4. Discord Discovery
5. Dry-Run Planning
6. Destination Copy
7. Validation
8. HITL Integration
9. Cleanup Authorization & Cleanup
10. End-to-End Testing & Hardening

Every phase follows:

```text
Inspect
  ↓
Understand
  ↓
Development Gate / HITL-0
  ↓
Implement current phase only
  ↓
Test
  ↓
Report
  ↓
Human Review / Phase Acceptance
```

A phase must not automatically trigger the next phase.

The first operational milestone deliberately stops after HITL #2:

```text
DISCOVER → PLAN → HITL #1 → COPY → VALIDATE → HITL #2 → STOP
```

Cleanup is a subsequent capability.

## 3. Phase 0 — Repository Foundation

### Objective

Create the independent GitHub repository and engineering conventions.

### Repository

`moriblo/discord-migrator`

The project is independent from `avalbot`.

### Entry Gate — HITL-0

Before changing the repository, MARGO must:

1. read `AGENT_SPEC.md`;
2. read `IMPLEMENTATION_PLAN.md`;
3. read the current Phase 0 prompt;
4. summarize the Phase 0 objective, deliverables, hard constraints, planned/prohibited actions, and stopping condition;
5. explicitly state that the phase is non-destructive;
6. request explicit human authorization to execute Phase 0.

No explicit authorization means no repository modification.

Silence, ambiguity, or approval intended for another action cannot authorize Phase 0.

### Deliverables

- repository foundation
- README
- AGENT_SPEC.md
- IMPLEMENTATION_PLAN.md
- versioned Phase 0 prompt under `prompts/`
- Python project configuration
- `.gitignore`
- test framework
- initial package structure
- basic CI workflow

### Proposed structure

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

### Acceptance criteria

- Repository exists.
- Project installs successfully.
- Tests execute.
- CI executes successfully.
- No Discord mutation capability exists yet.
- Phase 0 implementation does not proceed without HITL-0.
- Codex stops after Phase 0 and waits for human review.

## 4. Phase 1 — Configuration

### Objective

Externalize every migration-specific parameter.

Configuration must contain no secrets. Stable Discord IDs should be preferred for resource identity.

Example:

```json
{
  "migration": {
    "name": "initial-applications-migration",
    "mode": "dry-run"
  },
  "source": {
    "server_id": "${SOURCE_SERVER_ID}",
    "category_id": "${SOURCE_CATEGORY_ID}"
  },
  "destination": {
    "server_id": "${DESTINATION_SERVER_ID}",
    "category_id": null,
    "category_name": "Aplicações"
  },
  "policy": {
    "include_channels": true,
    "include_threads": false,
    "include_message_history": false,
    "allow_cleanup": false
  }
}
```

### Acceptance criteria

- Missing required configuration fails safely.
- Invalid configuration cannot start a migration.
- Secrets are not serialized into artifacts.
- No source/destination identity is hard-coded in application logic.

## 5. Phase 2 — State Machine

Implement explicit lifecycle control.

Primary states:

```text
DISCOVERED
PLANNED
WAITING_HITL_1
COPYING
COPIED
VALIDATING
VALIDATED
WAITING_HITL_2
READY_FOR_CLEANUP
WAITING_HITL_3
CLEANING_UP
COMPLETED
```

Failure/cancellation states:

```text
COPY_FAILED
VALIDATION_FAILED
CLEANUP_FAILED
CANCELLED
```

The state machine must reject invalid transitions. In particular:

- `WAITING_HITL_2` cannot transition directly to cleanup.
- `READY_FOR_CLEANUP` cannot transition to cleanup without HITL #3.
- `VALIDATED` cannot authorize deletion.

## 6. Phase 3 — Manifest & Evidence

Every execution receives a unique `run_id`.

Recommended artifacts:

```text
runs/<run-id>/
├── discovery.json
├── migration-manifest.json
├── migration-plan.json
├── copy-result.json
├── validation-result.json
├── hitl-decisions.json
├── cleanup-result.json
└── final-report.json
```

Artifacts must contain no credentials.

HITL events must be bound to the exact `run_id` and relevant plan/validation version or fingerprint.

## 7. Phase 4 — Discord Discovery

This phase is **READ ONLY**.

Discovery identifies:

- source server/category
- channels and IDs
- channel types
- hierarchy and positions
- descriptions/topics
- supported permissions
- relevant configuration
- unsupported features
- ambiguities

Discovery produces a normalized resource model and `discovery.json`.

No create, update, or delete operation is permitted.

## 8. Phase 5 — Dry-Run Planning

Dry-run is mandatory.

It may discover, compare, plan, and generate evidence, but must not:

- create categories
- create channels
- modify permissions
- delete channels
- delete categories

The planner produces explicit operations such as:

```text
CREATE
UPDATE
DELETE
WARNING
UNSUPPORTED
CONFLICT
```

The first dry-run must prove that no Discord mutation occurred.

## 9. Phase 6 — Destination Copy

Copy is permitted only when:

- state is `WAITING_HITL_1`;
- HITL #1 is approved;
- plan fingerprint is unchanged.

The executor creates only resources in the approved plan and records source-to-destination mappings.

Source resources remain untouched.

Partial failures must be detectable and represented in the run state and evidence.

## 10. Phase 7 — Validation

Validation independently compares expected and actual destination state.

Checks may include:

- resource existence
- identity
- type
- hierarchy
- position
- configuration
- permissions
- supported features

Statuses:

```text
PASS
FAIL
WARNING
NOT_SUPPORTED
NOT_CHECKED
```

A successful API response is not itself evidence of a successful migration.

## 11. Phase 8 — HITL Integration

### HITL #1 — Copy Authorization

Preconditions:

- discovery complete
- plan generated
- no blocking conflicts

Approval authorizes destination creation only.

### HITL #2 — Migration Ratification

Preconditions:

- copy completed
- validation completed
- validation acceptable
- relevant fingerprints unchanged

Approval means the human ratifies the migration result.

**It does not authorize cleanup.**

### HITL #3 — Cleanup Authorization

Preconditions:

- HITL #1 approved
- copy completed
- validation passed
- HITL #2 ratified
- cleanup scope unchanged

HITL #3 is a new, explicit decision event.

Only HITL #3 can enable source deletion.

## 12. Phase 9 — Cleanup

Cleanup is the highest-risk phase.

Immediately before deletion, the agent must verify:

```text
run_id
manifest fingerprint
validation status
HITL #1
HITL #2
HITL #3
cleanup scope
```

Only resources explicitly present in the approved migration manifest may be deleted.

No inferred deletion is permitted.

If any precondition fails:

```text
NO DELETE
```

## 13. Phase 10 — End-to-End Testing & Hardening

Testing must cover:

### Unit

- configuration
- state machine
- manifest
- planner
- validation
- authorization

### Integration

- Discord discovery
- destination creation
- permissions
- validation

### Safety

Prove explicitly:

```text
No HITL #1 → No COPY
No HITL #2 → No RATIFICATION
No HITL #3 → No DELETE
```

### Development governance

Prove:

```text
No HITL-0 → No Phase execution
Phase completed → STOP
No Phase acceptance → No next Phase
```

### Failure

Test API failures, missing permissions, partial copy, validation mismatch, stale approvals, changed manifests, and interrupted cleanup.

## 14. Initial Operational Run

Initial configuration:

```text
Source:
  aval / Aplicações

Destination:
  Moacyr Blondet / Aplicações
```

These values must exist only in external configuration.

The first real end-to-end run must stop after HITL #2:

```text
DRY-RUN
→ Review
→ HITL #1
→ COPY
→ VALIDATE
→ HITL #2
→ STOP
```

A later run can exercise HITL #3 and cleanup.

## 15. GitHub Development Workflow

The project should be developed through small, reviewable changes.

Suggested branches:

```text
main
├── feature/config
├── feature/state-machine
├── feature/discovery
├── feature/planner
├── feature/copy
├── feature/validation
├── feature/hitl
└── feature/cleanup
```

Each feature should include implementation, tests, and necessary documentation updates.

Cleanup must be isolated from the initial non-destructive implementation.

## 16. Prompt and Execution Governance

Prompts used to implement MARGO are versioned project artifacts under `prompts/`.

For each phase, Codex must:

1. inspect the current repository;
2. read the authoritative specification and implementation plan;
3. read the current phase prompt;
4. summarize its understanding;
5. obtain the required development authorization (HITL-0);
6. implement only the current phase;
7. run tests;
8. report deviations;
9. stop for human review.

Codex must never infer authorization for a development phase or destructive operational action.

Successful execution of one phase does not authorize the next phase.

## 17. Definition of Done

The project is production-ready only when:

- [ ] Configuration is fully externalized.
- [ ] Discovery is read-only.
- [ ] Dry-run is operational.
- [ ] State machine is enforced.
- [ ] Manifest is bound to the run.
- [ ] Evidence is persisted.
- [ ] HITL #1 is mandatory.
- [ ] Copy is scoped to the approved plan.
- [ ] Validation is independent.
- [ ] HITL #2 is mandatory.
- [ ] HITL #2 cannot authorize cleanup.
- [ ] HITL #3 is mandatory.
- [ ] Cleanup is manifest-scoped.
- [ ] Final pre-delete guard exists.
- [ ] Secrets are protected.
- [ ] Unit, integration, and safety tests pass.
- [ ] Initial `aval` → `Moacyr Blondet` migration succeeds without hard-coded identities.
- [ ] Final evidence is persisted in JSON.
- [ ] Development governance gates are respected throughout implementation.

## 18. Guiding Principle

The implementation should optimize for **controlled autonomy**, not maximum autonomy.

```text
Agent understands
      ↓
Human authorizes development
      ↓
Agent executes
      ↓
Agent validates
      ↓
Human reviews
      ↓
Human authorizes next phase
```

Operationally:

```text
Agent discovers
      ↓
Agent analyzes
      ↓
Agent proposes
      ↓
Human authorizes
      ↓
Agent executes
      ↓
Agent validates
      ↓
Human ratifies
      ↓
Human explicitly authorizes destruction
      ↓
Agent executes cleanup
      ↓
Agent produces evidence
```
