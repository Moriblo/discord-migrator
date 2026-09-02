# Discord Migrator — Implementation Plan

**Repository:** `moriblo/discord-migrator`  
**Product:** Discord Migrator — Human-Governed Migration Agent  
**Agent:** **MARGO — Migration & Resource Governance Operator**  
**Specification:** `AGENT_SPEC.md`  
**Status:** Implementation planning  
**Version:** 0.3

---

## 1. Implementation Objective

Build MARGO incrementally, beginning with a fully non-destructive foundation and enabling progressively higher-risk capabilities only after the preceding phase has been implemented, tested, reviewed, and explicitly accepted.

Core operational governance:

- **HITL #1:** authorization to COPY
- **HITL #2:** ratification of VALIDATION
- **HITL #3:** authorization to DELETE

No operational approval may be reused for another gate.

Development itself has a separate governance checkpoint:

- **HITL-0:** authorization to execute the current development phase

HITL-0 is not an operational migration approval.

---

## 2. Implementation Strategy

### 2.1 Phases

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

### 2.2 Development execution flow

Every phase follows exactly this governed sequence:

```text
INSPECT
   ↓
UNDERSTAND
   ↓
HITL-0 — PHASE EXECUTION AUTHORIZATION
   ↓
IMPLEMENT CURRENT PHASE ONLY
   ↓
TEST
   ↓
REPORT
   ↓
HUMAN REVIEW
   ↓
PHASE ACCEPTANCE
   ↓
NEXT PHASE
```

MARGO MUST explicitly announce material transitions during execution.

A transition announcement uses:

```text
[MARGO STEP n] <STATE>
Action: <what is being performed>
Evidence: <what was verified>
Result: <result>
Next: <next state>
```

Completion of a phase does not authorize the next phase.

### 2.3 Operational migration flow

The first real end-to-end operational milestone deliberately stops after HITL #2:

```text
DISCOVER
   ↓
PLAN
   ↓
HITL #1
   ↓
COPY
   ↓
VALIDATE
   ↓
HITL #2
   ↓
STOP
```

Cleanup is a subsequent capability and requires HITL #3.

---

## 3. Development Authorization Integrity

Before modifying the repository for a phase, MARGO MUST:

1. inspect the current repository;
2. read `AGENT_SPEC.md`;
3. read `IMPLEMENTATION_PLAN.md`;
4. read the applicable versioned phase prompt;
5. present its understanding of the phase;
6. present objectives and deliverables;
7. present hard constraints and prohibited actions;
8. present planned actions;
9. state the stopping condition;
10. explicitly state the non-destructive boundary when applicable;
11. request explicit HITL-0 authorization.

### 3.1 No inferred authorization

HITL-0 MUST NOT be inferred from:

- script execution;
- prompt execution;
- previous approval;
- conversational intent;
- silence or lack of objection;
- successful completion of a previous phase;
- automated state transitions.

Only an explicit human authorization for the current phase may release the phase implementation gate.

### 3.2 Phase exit

After implementation, testing, and reporting:

```text
PHASE COMPLETE
      ↓
STOP
      ↓
HUMAN REVIEW
      ↓
PHASE ACCEPTANCE
      ↓
EXPLICIT AUTHORIZATION FOR NEXT PHASE
```

MARGO MUST NOT automatically begin the next phase.

---

## 4. Phase 0 — Repository Foundation

### Objective

Create the minimal engineering foundation for MARGO.

Phase 0 is fully non-destructive.

### Entry Gate — HITL-0

Before any repository modification, MARGO must:

1. read `AGENT_SPEC.md`;
2. read this implementation plan;
3. read `prompts/phase-0-repository-foundation.md`;
4. summarize the phase;
5. request explicit HITL-0 authorization.

No explicit authorization means no repository modification.

### Deliverables

- repository foundation;
- `README.md`;
- `AGENT_SPEC.md` preservation;
- `IMPLEMENTATION_PLAN.md` preservation;
- versioned Phase 0 prompt;
- Python project configuration;
- `.gitignore`;
- pytest test framework;
- initial package/module structure;
- configuration example;
- configuration documentation;
- `runs/.gitkeep`;
- basic CI workflow.

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

### Phase 0 prohibitions

Do NOT:

- implement real Discord API integration;
- create, update, move, rename, or delete Discord resources;
- implement source cleanup;
- implement executable operational HITL approval logic;
- introduce Discord credentials, tokens, or secrets;
- hard-code migration-specific identities;
- implement later-phase behavior;
- silently change architecture;
- use a script to grant authorization.

### Phase 0 tests

At minimum prove that:

- the Python package can be imported;
- pytest executes;
- the foundation contains no active Discord mutation implementation;
- configuration examples contain no credentials;
- the repository remains free of committed secrets.

### Phase 0 CI

A basic CI workflow must run the Phase 0 test suite and fail on test failure.

### Phase 0 stopping condition

After implementation:

1. run the complete Phase 0 test suite;
2. report exact commands and results;
3. report repository structure;
4. report deviations;
5. explicitly confirm the non-destructive boundary;
6. STOP.

Phase 1 is not authorized by Phase 0 completion.

---

## 5. Phase 1 — Configuration

Externalize every migration-specific parameter.

Configuration must contain no secrets. Stable Discord IDs should be preferred for identity.

Acceptance:

- missing required configuration fails safely;
- invalid configuration cannot start a migration;
- secrets are not serialized into artifacts;
- no source/destination identity is hard-coded in application logic.

---

## 6. Phase 2 — State Machine

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

The state machine must reject invalid transitions.

---

## 7. Phase 3 — Manifest & Evidence

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

HITL events must be bound to the exact `run_id` and relevant plan/validation fingerprint or version.

---

## 8. Phase 4 — Discord Discovery

This phase is READ ONLY.

Discovery identifies:

- source server/category;
- channels and IDs;
- channel types;
- hierarchy and positions;
- descriptions/topics;
- supported permissions;
- relevant configuration;
- unsupported features;
- ambiguities.

Discovery produces a normalized resource model and `discovery.json`.

No create, update, or delete operation is permitted.

---

## 9. Phase 5 — Dry-Run Planning

Dry-run is mandatory.

It may discover, compare, plan, and generate evidence, but must not:

- create categories;
- create channels;
- modify permissions;
- delete channels;
- delete categories.

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

---

## 10. Phase 6 — Destination Copy

Copy is permitted only when:

- state is `WAITING_HITL_1`;
- HITL #1 is approved;
- plan fingerprint is unchanged.

The executor creates only resources in the approved plan and records source-to-destination mappings.

Source resources remain untouched.

Partial failures must be detectable and represented in run state and evidence.

---

## 11. Phase 7 — Validation

Validation independently compares expected and actual destination state.

Checks may include:

- resource existence;
- identity;
- type;
- hierarchy;
- position;
- configuration;
- permissions;
- supported features.

Statuses:

```text
PASS
FAIL
WARNING
NOT_SUPPORTED
NOT_CHECKED
```

A successful API response is not itself evidence of a successful migration.

---

## 12. Phase 8 — HITL Integration

### HITL #1 — Copy Authorization

Preconditions:

- discovery complete;
- plan generated;
- no blocking conflicts.

Approval authorizes destination creation only.

### HITL #2 — Migration Ratification

Preconditions:

- copy completed;
- validation completed;
- validation acceptable;
- relevant fingerprints unchanged.

Approval ratifies the migration result.

**It does not authorize cleanup.**

### HITL #3 — Cleanup Authorization

Preconditions:

- HITL #1 approved;
- copy completed;
- validation passed;
- HITL #2 ratified;
- cleanup scope unchanged.

HITL #3 is a new explicit decision event.

Only HITL #3 can enable source deletion.

---

## 13. Phase 9 — Cleanup

Cleanup is the highest-risk phase.

Immediately before deletion, verify:

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

---

## 14. Phase 10 — End-to-End Testing & Hardening

Testing must cover:

### Unit

- configuration;
- state machine;
- manifest;
- planner;
- validation;
- authorization.

### Integration

- Discord discovery;
- destination creation;
- permissions;
- validation.

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

Test:

- API failures;
- missing permissions;
- partial copy;
- validation mismatch;
- stale approvals;
- changed manifests;
- interrupted cleanup.

---

## 15. Initial Operational Run

Initial configuration represents:

```text
Source:
  aval / Aplicações

Destination:
  Moacyr Blondet / Aplicações
```

These values exist only in external configuration.

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

A later run may exercise HITL #3 and cleanup.

---

## 16. GitHub Development Workflow

The project should be developed through small, reviewable changes.

Suggested feature branches:

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

Each feature should include implementation, tests, and required documentation updates.

Cleanup must remain isolated from the initial non-destructive implementation.

---

## 17. Codex and MARGO Execution Rules

Codex/MARGO must use:

1. `AGENT_SPEC.md` as the authoritative specification;
2. this document as the implementation sequence;
3. the versioned phase prompt as the execution instruction for the current phase.

For each phase MARGO must:

1. inspect;
2. understand;
3. announce the current state;
4. reach HITL-0;
5. request explicit authorization;
6. implement only the current phase after authorization;
7. test;
8. report;
9. stop;
10. wait for human review and phase acceptance.

MARGO must announce material transitions using:

```text
[MARGO STEP n] <STATE>
Action: <what is being performed>
Evidence: <what was verified>
Result: <result>
Next: <next state>
```

MARGO must never infer authorization for destructive actions or development-phase execution.

---

## 18. Definition of Done

The project is production-ready only when:

- [ ] configuration is fully externalized;
- [ ] discovery is read-only;
- [ ] dry-run is operational;
- [ ] state machine is enforced;
- [ ] manifest is bound to the run;
- [ ] evidence is persisted;
- [ ] HITL #1 is mandatory;
- [ ] copy is scoped to the approved plan;
- [ ] validation is independent;
- [ ] HITL #2 is mandatory;
- [ ] HITL #2 cannot authorize cleanup;
- [ ] HITL #3 is mandatory;
- [ ] cleanup is manifest-scoped;
- [ ] final pre-delete guard exists;
- [ ] secrets are protected;
- [ ] unit, integration, and safety tests pass;
- [ ] initial migration succeeds without hard-coded identities;
- [ ] final evidence is persisted in JSON;
- [ ] development phases are individually authorized and accepted.

---

## 19. Guiding Principle

The implementation optimizes for **controlled autonomy**, not maximum autonomy.

```text
Agent inspects
      ↓
Agent understands
      ↓
Agent announces transition
      ↓
Human authorizes
      ↓
Agent executes authorized scope
      ↓
Agent tests/validates
      ↓
Agent reports
      ↓
Human reviews/accepts
      ↓
Next phase requires explicit authorization
```

Operationally:

```text
Agent discovers
      ↓
Agent analyzes
      ↓
Agent proposes
      ↓
Human authorizes COPY
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

---

## 20. Document Consistency Rule

`AGENT_SPEC.md`, `IMPLEMENTATION_PLAN.md`, and the applicable versioned phase prompt must remain mutually consistent.

If a conflict is discovered:

1. stop;
2. report the exact conflict;
3. do not silently choose one interpretation;
4. obtain human direction before changing an authoritative decision.

Scripts are subordinate implementation helpers and must not override these documents.
