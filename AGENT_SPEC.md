# Discord Resource Migration Agent --- Agent Specification

**Document status:** Draft for implementation\
**Version:** 0.3\
**Owner:** `moriblo`\
**Initial use case:** Discord channel migration\
**Implementation environment:** Codex\
**Primary objective:** Safe, auditable, human-controlled migration of
Discord resources

------------------------------------------------------------------------

## 1. Purpose

This document defines the functional, architectural, security,
governance, and testing requirements for a generic **Discord Resource
Migration Agent**.

The first implementation will migrate all channels belonging to a
configured category from one Discord server to another. The initial
operational scenario is:

-   **Source server:** `aval`
-   **Source category:** `Aplicações`
-   **Destination server:** `Moacyr Blondet`
-   **Destination category:** configurable; initially `Aplicações`

These values are **configuration data only**. They must not be
hard-coded into application logic.

The agent must support a controlled sequence:

1.  discover;
2.  plan;
3.  obtain HITL #1 approval;
4.  copy;
5.  validate;
6.  obtain HITL #2 ratification;
7.  obtain HITL #3 cleanup authorization;
8.  perform cleanup;
9.  produce final evidence.

No destructive operation may occur before HITL #3.

------------------------------------------------------------------------

## 2. Scope

### 2.1 In scope for V1

-   Discovery of configured Discord servers, categories, and channels.
-   Generation of a migration plan.
-   Dry-run execution.
-   Creation of destination category/channel structure.
-   Replication of supported channel configuration and permissions.
-   Validation of copied resources.
-   Human approval gates.
-   State management.
-   Audit logging.
-   Persistent JSON execution artifacts.
-   Cleanup of explicitly approved source resources.
-   Failure detection and safe stopping.
-   Automated tests.

### 2.2 Out of scope for V1 unless explicitly implemented and tested

-   Migration of arbitrary Discord resources beyond the supported
    channel types.
-   Automatic migration of message history when Discord/API limitations
    prevent it.
-   Automatic deletion of resources outside the migration manifest.
-   Automatic modification of unrelated channels, categories, roles, or
    servers.
-   Autonomous approval of any HITL gate.

The architecture must nevertheless allow future expansion to additional
Discord resource types.

------------------------------------------------------------------------

## 3. Design Principles

1.  **Safety before automation.**
2.  **Least privilege.**
3.  **Human authorization for critical actions.**
4.  **No destructive action without explicit authorization.**
5.  **Configuration over hard-coding.**
6.  **Deterministic and auditable execution.**
7.  **Fail closed.**
8.  **Idempotent operations whenever technically possible.**
9.  **Evidence must survive the execution itself.**
10. **The agent must be generic; migration-specific data belongs in
    configuration.**
11. **The first version must be usable in dry-run mode.**
12. **The existing `avalbot`/Pirate application is completely
    independent from this project.**

------------------------------------------------------------------------

## 4. Terminology

### Agent

The software responsible for discovery, planning, migration, validation,
HITL coordination, cleanup, and evidence generation.

### Migration Run

One complete execution identified by a unique `run_id`.

### Source

The Discord server/category/channel resources from which resources are
copied.

### Destination

The Discord server/category/channel location where resources are
recreated.

### Migration Manifest

The immutable description of the resources identified for a specific
migration run.

### HITL

Human-in-the-Loop approval required at a defined decision gate.

### Dry-Run

Execution in which discovery, planning, comparison, and expected actions
are performed without making write or destructive changes to Discord.

### Cleanup

Deletion of source resources after successful migration and explicit
HITL #3 authorization.

------------------------------------------------------------------------

## 5. Functional Requirements

### FR-001 --- External Configuration

All migration-specific values must be supplied externally.

The application must not contain hard-coded:

-   server names;
-   server IDs;
-   category names;
-   category IDs;
-   channel names;
-   channel IDs;
-   migration-specific role IDs;
-   migration-specific operational parameters.

Configuration should use stable Discord IDs wherever possible, with
human-readable names retained for reporting.

### FR-002 --- Discovery

The agent must inspect the configured source and destination and
generate a discovery artifact.

### FR-003 --- Planning

The agent must generate a plan before any write operation.

### FR-004 --- HITL #1

No destination creation may occur before explicit HITL #1 approval.

### FR-005 --- Copy

The agent must create only resources authorized by the approved
migration plan.

### FR-006 --- Validation

The agent must independently validate the destination against the
migration manifest and expected configuration.

### FR-007 --- HITL #2

The agent must present validation evidence and require explicit human
ratification.

HITL #2 does not authorize cleanup.

### FR-008 --- HITL #3

The agent must require a new explicit approval before any source
deletion.

### FR-009 --- Cleanup

Cleanup must be limited to source resources explicitly included in the
approved migration manifest.

### FR-010 --- Audit

Every significant operation and every HITL decision must be recorded.

### FR-011 --- Persistence

Execution results must be saved as JSON artifacts in the repository.

### FR-012 --- Final Report

Every completed or failed run must produce a final report.

------------------------------------------------------------------------

## 6. Architecture

The logical architecture is:

``` text
                 ┌─────────────────────────┐
                 │         Codex           │
                 │ Development environment │
                 └────────────┬────────────┘
                              │
                              ▼
                 ┌─────────────────────────┐
                 │ Discord Resource       │
                 │ Migration Agent        │
                 └────────────┬────────────┘
                              │
             ┌────────────────┼────────────────┐
             ▼                ▼                ▼
       Discord API       State Manager     Audit/Evidence
             │                │                │
       ┌─────┴─────┐          │                │
       ▼           ▼          ▼                ▼
    Source     Destination   Run State       JSON artifacts
```

The agent should be composed of independent modules:

-   `config`
-   `discord_client`
-   `discovery`
-   `planner`
-   `migration`
-   `validation`
-   `hitl`
-   `state`
-   `audit`
-   `reporting`
-   `cleanup`

The architecture must keep Discord-specific operations separated from
migration orchestration.

------------------------------------------------------------------------

## 7. Configuration Model

A migration configuration should be externally supplied, for example:

``` json
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
  "options": {
    "include_channels": true,
    "include_threads": false,
    "include_message_history": false,
    "cleanup_source": false
  }
}
```

Secrets and authentication tokens must never be committed to the
repository.

Environment variables or an approved secret-management mechanism must
supply credentials.

Configuration should distinguish:

-   **identity/configuration data**;
-   **credentials/secrets**;
-   **execution policy**.

------------------------------------------------------------------------

## 8. Migration Manifest

A migration run must produce an immutable manifest describing what the
agent intends to migrate.

Conceptually:

``` json
{
  "run_id": "mig-20260901-001",
  "source": {
    "server_id": "...",
    "category_id": "..."
  },
  "destination": {
    "server_id": "...",
    "category_id": "..."
  },
  "resources": [
    {
      "source_id": "...",
      "name": "...",
      "type": "text",
      "position": 1,
      "configuration": {},
      "permissions": {}
    }
  ]
}
```

The manifest is the authoritative boundary of the migration.

The cleanup engine must never delete resources merely because they exist
in the source category; it must verify that the resource is explicitly
represented in the approved manifest.

------------------------------------------------------------------------

## 9. State Machine

The primary state machine is:

``` text
DISCOVERED
    ↓
PLANNED
    ↓
WAITING_HITL_1
    ↓
COPYING
    ↓
COPIED
    ↓
VALIDATING
    ↓
VALIDATED
    ↓
WAITING_HITL_2
    ↓
READY_FOR_CLEANUP
    ↓
WAITING_HITL_3
    ↓
CLEANING_UP
    ↓
COMPLETED
```

Failure/cancellation states include:

``` text
COPY_FAILED
VALIDATION_FAILED
CLEANUP_FAILED
CANCELLED
```

The agent must reject invalid state transitions.

In particular:

-   `WAITING_HITL_1` cannot transition directly to cleanup.
-   `WAITING_HITL_2` cannot transition directly to cleanup.
-   `VALIDATED` cannot itself authorize deletion.
-   `READY_FOR_CLEANUP` cannot itself authorize deletion.
-   only an explicit HITL #3 approval for the current `run_id` may
    enable cleanup.

------------------------------------------------------------------------

## 10. HITL Model

### 10.1 HITL #1 --- Copy Authorization

Purpose:

> Approve execution of the planned copy operation.

Evidence presented:

-   source;
-   destination;
-   resources to be created;
-   configuration differences;
-   unsupported features;
-   expected impact;
-   dry-run result.

Approval authorizes destination creation only.

### 10.2 HITL #2 --- Migration Ratification

Purpose:

> Confirm that the completed copy and validation results are technically
> acceptable.

Evidence presented:

-   resources discovered;
-   resources copied;
-   validation results;
-   permission checks;
-   configuration checks;
-   failures/warnings;
-   source-side changes.

HITL #2 must not authorize cleanup.

### 10.3 HITL #3 --- Cleanup Authorization

Purpose:

> Explicitly authorize irreversible removal of the source resources.

Evidence presented:

-   source resources to be deleted;
-   destination resources;
-   successful validation;
-   HITL #1 decision;
-   HITL #2 decision;
-   exact cleanup scope;
-   warning that the action is destructive.

HITL #3 must be a new decision event.

An approval from HITL #2 must never be reused as HITL #3.

------------------------------------------------------------------------

## 11. Guardrails

The following are mandatory:

### G-001 --- No implicit deletion

No DELETE operation may be inferred from configuration or from
successful validation.

### G-002 --- HITL #3 required

No cleanup without an explicit HITL #3 approval.

### G-003 --- Scope lock

Cleanup is restricted to the resources present in the approved migration
manifest.

### G-004 --- Run binding

HITL approvals must be associated with the exact `run_id`.

### G-005 --- Plan binding

If the migration plan changes materially after HITL #1, the previous
approval becomes invalid and a new HITL #1 is required.

### G-006 --- Validation binding

If destination resources change after validation, HITL #2 becomes
invalid.

### G-007 --- Cleanup binding

If cleanup scope changes after HITL #3, cleanup authorization becomes
invalid.

### G-008 --- Fail closed

Errors, missing approvals, inconsistent state, missing credentials, or
ambiguous resource identity must stop the operation.

### G-009 --- No credential persistence

Discord credentials/tokens must never be written to run artifacts.

### G-010 --- No unrelated mutations

The agent must not modify Discord resources outside the approved
migration scope.

------------------------------------------------------------------------

## 12. Dry-Run Mode

Dry-run is a mandatory operating mode.

In dry-run:

-   Discord resources may be read;
-   discovery occurs;
-   planning occurs;
-   comparisons occur;
-   expected operations are calculated;
-   validation logic may be exercised against discovered state;
-   artifacts are generated;

but:

-   no category creation occurs;
-   no channel creation occurs;
-   no permission modification occurs;
-   no source deletion occurs.

Dry-run must clearly identify that no Discord resources were modified.

------------------------------------------------------------------------

## 13. Discovery

Discovery must collect only the information required by the configured
migration policy.

The discovery result must include:

-   server identity;
-   category identity;
-   channel identity;
-   channel type;
-   position;
-   supported configuration;
-   supported permissions;
-   relevant relationships;
-   unsupported or ambiguous attributes.

Discovery must distinguish:

-   confirmed information;
-   inferred information;
-   unsupported information;
-   errors.

------------------------------------------------------------------------

## 14. Planning

The planner converts discovery results into a deterministic migration
plan.

The plan must identify:

-   CREATE operations;
-   UPDATE operations, if any;
-   DELETE operations planned for cleanup;
-   unsupported features;
-   potential conflicts;
-   expected differences.

The planner must not execute operations.

------------------------------------------------------------------------

## 15. Copy/Migration

The migration engine executes only the approved plan.

Operations should be:

-   logged;
-   individually identifiable;
-   idempotent when possible;
-   recoverable where possible.

If a copy operation fails, the agent must stop or enter a clearly
defined failure state rather than silently continuing.

Partial execution must be represented in the run artifacts.

------------------------------------------------------------------------

## 16. Validation

Validation must compare expected and actual destination state.

Validation should include, where supported:

-   resource existence;
-   names;
-   types;
-   hierarchy;
-   positions;
-   topics/descriptions;
-   permissions;
-   supported configuration;
-   relationships.

Validation results must use explicit statuses such as:

``` text
PASS
FAIL
WARNING
NOT_SUPPORTED
NOT_CHECKED
```

A `PASS` means the specific check passed; it must not conceal
unsupported or unchecked areas.

------------------------------------------------------------------------

## 17. Cleanup

Cleanup is a privileged, destructive phase.

Before cleanup the agent must verify:

1.  current `run_id`;
2.  migration manifest;
3.  successful validation;
4.  HITL #1 approval;
5.  HITL #2 ratification;
6.  explicit HITL #3 approval;
7.  unchanged cleanup scope.

Only then may DELETE operations be enabled.

The cleanup engine must perform a final pre-delete check immediately
before deletion.

------------------------------------------------------------------------

## 18. Failure Handling

The agent must prefer stopping over guessing.

Examples:

### Missing destination permission

Result:

``` text
VALIDATION_FAILED
```

No cleanup.

### Channel copied but permission replication failed

Result:

``` text
VALIDATION_FAILED
```

No cleanup.

### HITL #2 rejected

Result:

``` text
CANCELLED
```

No cleanup.

### HITL #3 rejected

Result:

``` text
READY_FOR_CLEANUP
```

Source remains untouched.

### Cleanup partially fails

Result:

``` text
CLEANUP_FAILED
```

The agent must not automatically retry destructive operations without a
defined and auditable retry policy.

------------------------------------------------------------------------

## 19. Audit and Evidence

Each migration run must produce persistent JSON artifacts.

Recommended structure:

``` text
runs/
└── <run-id>/
    ├── discovery.json
    ├── migration-manifest.json
    ├── migration-plan.json
    ├── copy-result.json
    ├── validation-result.json
    ├── hitl-decisions.json
    ├── cleanup-result.json
    └── final-report.json
```

Each significant event should include:

-   `run_id`;
-   event type;
-   timestamp;
-   actor;
-   state before;
-   state after;
-   resource identifier where applicable;
-   result;
-   error/warning information where applicable.

HITL decisions must include:

-   gate;
-   decision;
-   actor;
-   timestamp;
-   associated run;
-   associated plan/validation version.

------------------------------------------------------------------------

## 20. Repository Structure

The initial repository should be independent from `avalbot`.

Suggested structure:

``` text
discord-resource-migration-agent/
│
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
│
├── config/
│   ├── migration.example.json
│   └── README.md
│
├── runs/
│   └── .gitkeep
│
├── tests/
│
├── docs/
│
├── AGENT_SPEC.md
├── README.md
├── pyproject.toml
└── .gitignore
```

The actual GitHub repository is expected to belong to `moriblo`.

------------------------------------------------------------------------

## 21. Persisted Run Artifacts

Run artifacts are part of the product, not temporary debug output.

They provide:

-   auditability;
-   reproducibility;
-   troubleshooting;
-   governance evidence;
-   migration history;
-   post-run review.

The implementation must define whether generated run artifacts are
committed automatically, committed only after review, or stored through
another controlled repository mechanism.

The V1 implementation should favor transparent JSON evidence and avoid
storing secrets or unnecessary sensitive Discord data.

------------------------------------------------------------------------

## 22. Security Requirements

The agent must use least-privilege Discord permissions.

Recommended operational separation:

### Discovery/COPY role

May:

-   read source;
-   create destination resources;
-   configure destination resources as required.

Must not:

-   delete source resources.

### CLEANUP role/capability

May delete source resources only when the application state contains
valid HITL #3 authorization.

Where Discord permissions cannot be dynamically separated, the
application must still enforce an internal authorization barrier and the
deployment configuration must minimize available destructive permissions
during development/testing.

Credentials must be supplied securely and excluded from Git.

------------------------------------------------------------------------

## 23. Testing Strategy

Testing must occur in layers.

### Unit tests

Test:

-   configuration parsing;
-   manifest generation;
-   state transitions;
-   authorization rules;
-   validation comparison;
-   cleanup scope calculation.

### Integration tests

Test against Discord APIs using controlled resources.

### Dry-run tests

Verify that dry-run never performs writes.

### Guardrail tests

Explicitly test that:

-   HITL #2 cannot trigger deletion;
-   missing HITL #3 blocks deletion;
-   changed manifests invalidate approvals;
-   changed validation invalidates HITL #2;
-   changed cleanup scope invalidates HITL #3;
-   unrelated resources cannot be deleted.

### Failure tests

Test:

-   missing permissions;
-   API errors;
-   partial copy;
-   validation failure;
-   approval rejection;
-   interrupted cleanup.

------------------------------------------------------------------------

## 24. Initial Migration Scenario

The first migration configuration will represent:

``` text
SOURCE
  Server: aval
  Category: Aplicações

DESTINATION
  Server: Moacyr Blondet
  Category: Aplicações
```

The operational sequence is:

``` text
1. DRY-RUN
2. Review discovery and plan
3. HITL #1
4. COPY
5. VALIDATE
6. HITL #2
7. WAIT
8. HITL #3
9. CLEANUP
10. FINAL REPORT
```

No source resources are to be removed until step 9.

------------------------------------------------------------------------

## 25. Future Extensibility

The architecture must allow future migration scenarios without changing
the core orchestration logic.

Potential future capabilities include:

-   moving individual channels;
-   moving multiple categories;
-   moving resources between arbitrary servers;
-   supporting additional Discord resource types;
-   richer permission mapping;
-   migration templates;
-   scheduled migration runs;
-   migration rollback/compensation strategies;
-   policy-driven approvals;
-   additional validation plugins.

Future functionality must preserve the same safety principles and HITL
model.

------------------------------------------------------------------------

## 26. Acceptance Criteria

V1 is considered acceptable only when all of the following are true:

-   [ ] Source and destination are fully externalized.
-   [ ] No migration-specific server/channel identifiers are hard-coded.
-   [ ] Dry-run works.
-   [ ] Discovery produces JSON evidence.
-   [ ] Planning produces JSON evidence.
-   [ ] HITL #1 is mandatory before copy.
-   [ ] Copy operations are auditable.
-   [ ] Validation produces JSON evidence.
-   [ ] HITL #2 is mandatory after validation.
-   [ ] HITL #2 cannot authorize cleanup.
-   [ ] HITL #3 is mandatory before cleanup.
-   [ ] Cleanup is restricted to the approved manifest.
-   [ ] Cleanup performs a final authorization/scope check.
-   [ ] Run artifacts are persisted.
-   [ ] Secrets are never persisted.
-   [ ] Failure states stop unsafe execution.
-   [ ] Guardrail tests pass.
-   [ ] The initial `aval` → `Moacyr Blondet` migration can be executed
    using configuration only.

------------------------------------------------------------------------

## 27. Governance Principle

The central governance principle of this agent is:

> **Automation may execute approved actions, but it must never infer
> human authorization for irreversible actions.**

For this reason:

``` text
HITL #1 = Authorization to COPY
HITL #2 = Ratification of VALIDATION
HITL #3 = Authorization to DELETE
```

These are three separate decisions with three separate audit events.

------------------------------------------------------------------------

## 28. Implementation Starting Point

The implementation should proceed in this order:

1.  Repository initialization.
2.  Configuration model.
3.  State machine.
4.  Discord read-only client.
5.  Discovery.
6.  Manifest generation.
7.  Dry-run planner.
8.  HITL #1.
9.  Destination copy.
10. Validation.
11. HITL #2.
12. Cleanup authorization model.
13. HITL #3.
14. Cleanup implementation.
15. Audit/evidence hardening.
16. Full integration test.
17. Initial migration.

**Important:** cleanup should not be implemented as an active capability
until the non-destructive phases and their guardrails have been tested
successfully.

---

---

## 29. Development Governance, Human Authorization Integrity & Execution Observability

The development of MARGO is itself governed. Development authorization is distinct from operational migration authorization.

### 29.1 HITL-0 — Phase Execution Authorization

**HITL-0** is the explicit human authorization required before MARGO may execute a development phase.

HITL-0 is distinct from:

- **HITL #1** — COPY authorization;
- **HITL #2** — VALIDATION ratification;
- **HITL #3** — DELETE authorization.

HITL-0 authorizes only the specific development phase explicitly identified in the human decision.

No authorization may be reused, propagated, or inferred for another phase or another governance gate.

### 29.2 Human Authorization Integrity

Human authorization MUST be explicit.

Human authorization MUST NOT be inferred from:

- script execution;
- prompt execution;
- previous authorization;
- conversational intent;
- silence or lack of objection;
- successful completion of a previous phase;
- automated state transitions.

Automated mechanisms may request, display, record, or validate authorization state, but MUST NOT grant human authorization.

A successful implementation, successful test suite, or successful prior phase does not authorize the next phase.

### 29.3 Fail-Closed Development Gate

Before a development phase is authorized, MARGO MUST:

1. inspect the authoritative specification;
2. inspect the implementation plan;
3. inspect the applicable versioned phase prompt;
4. present its understanding of the current phase;
5. identify objectives and deliverables;
6. identify hard constraints and prohibited actions;
7. state the planned actions;
8. state the stopping condition;
9. explicitly state the non-destructive boundary when applicable;
10. request explicit human authorization.

If explicit authorization is absent, ambiguous, or intended for another action, MARGO MUST STOP without implementing the phase.

### 29.4 Phase Transition Integrity

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

Completion of a phase MUST NOT automatically authorize or trigger the next phase.

MARGO MUST stop after the current phase and wait for human review and explicit authorization before proceeding.

### 29.5 Execution Observability

MARGO executions MUST expose their current execution state and significant transitions to the human operator.

At minimum, a governed execution should make visible:

- `run_id`;
- repository;
- branch or execution context where relevant;
- current phase;
- current stage/state;
- authorization state;
- action being performed;
- relevant evidence or verification result;
- resulting state;
- next expected state;
- stopping/waiting condition.

MARGO MUST announce material transitions, including entry into and exit from governance gates, in a consistent form:

```text
[MARGO STEP n] <STATE>
Action: <what is being performed>
Evidence: <what was verified>
Result: <result>
Next: <next state>
```

The transition announcement is part of operational observability and auditability. It is not itself an authorization mechanism.

### 29.6 Run Identity

Each MARGO execution SHOULD have a unique `run_id`.

The `run_id` is the correlation identifier for:

- execution state;
- significant events;
- evidence;
- human decisions;
- reports.

A bootstrap may generate or display a runtime `run_id`, but persistent run artifacts remain governed by the implementation plan and the dedicated evidence/state implementation.

### 29.7 Bootstrap Responsibilities

Bootstrap scripts are operational helpers only.

A bootstrap script MAY:

- validate required local prerequisites;
- identify the repository and current context;
- load or reference authoritative documents and phase instructions;
- generate/display a runtime `run_id`;
- display governance state;
- launch the governed MARGO session.

A bootstrap script MUST NOT:

- grant HITL-0;
- grant operational HITL #1, #2, or #3;
- infer authorization from execution;
- persist credentials or authentication secrets;
- become an alternative source of architectural truth;
- bypass a phase prompt or authoritative governance rule.

### 29.8 Device Authentication

Codex authentication for remote/headless development environments may use interactive device-code authentication.

Project helper scripts may initiate the device-code flow, but MUST NOT:

- store passwords;
- store device codes;
- store access tokens;
- automate browser authentication;
- commit credentials to Git;
- bypass the authentication security boundary.

### 29.9 Governance Invariant

The central development-governance invariant is:

> **Automation may prepare, observe, and execute an explicitly authorized development action, but it must never infer or manufacture the human authorization required to perform it.**
