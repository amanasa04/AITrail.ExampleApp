# Tasks: AI Trail Individual Progress Tracking System

## Phase 1 - Spec and data contracts
1. [x] Create `tracking/rubric/rubric.v1.json` using level model from AI-Trail-Progression-Summary.
2. [x] Define JSON Schemas for rubric, progress, evidence, review event, promotion event.
3. [x] Add sample files:
- `tracking/progress/sample-user.json`
- `tracking/events/review-events.jsonl`
- `tracking/events/promotion-events.jsonl`

## Phase 2 - Validation tooling
4. [x] Implement `tracking/scripts/validate.ps1` to validate all JSON against schemas.
5. [x] Add workflow validation logic:
- no promotion without required approvals
- rejection requires comment
- level transitions validated
6. [x] Add clear error output with file path and failing rule.

## Phase 3 - Reporting and operations
7. [x] Implement `tracking/scripts/generate-reports.ps1`.
8. [x] Generate CSV outputs:
- individual readiness
- team level distribution
- pending review queue
9. [x] Document operational runbook in `tracking/README.md`.

## Phase 4 - Governance hardening
10. [x] Add rubric version management guidance and change log policy.
11. [x] Add reviewer/approver role matrix and approval SLA section.
12. [x] Add rollback/reopen policy for contested promotions.

## Validation checklist
- [x] All schema validations pass.
- [x] Sample progress workflow runs end-to-end.
- [x] Report output is generated without manual edits.
- [x] Promotion gating rules enforced.
- [x] Audit trail entries captured for each decision.

## Suggested task execution order
- Execute tasks 1-3 first.
- Then execute tasks 4-6.
- Then execute tasks 7-9.
- Finish with tasks 10-12.

## Notes
- Keep all artifacts ASCII and repository-local.
- Do not include secrets/PII in evidence sample data.
- Preserve append-only semantics for event logs.
