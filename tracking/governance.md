# Governance Policy: AI Trail Tracking

## 1) Rubric version management and change log policy
- Rubric files are versioned with semantic versioning: `MAJOR.MINOR.PATCH`.
- `PATCH`: wording clarifications that do not change advancement logic.
- `MINOR`: additive criteria or metadata fields that do not break existing records.
- `MAJOR`: breaking changes to levels, required criteria, or promotion gates.

### Change control
- Proposed changes require:
  - author
  - rationale
  - impact summary
  - effective date
- Every rubric change must be recorded in `tracking/rubric/CHANGELOG.md`.
- Progress records must remain pinned to their assigned `rubric_version`.
- No in-place mutation of historical versions; publish a new version file when behavior changes.

## 2) Reviewer and approver role matrix with SLA
| Role | Can Submit Evidence | Can Review Criteria | Can Promote Level | Can Modify Rubric |
|---|---|---|---|---|
| Engineer | Yes (own record) | No | No | No |
| Reviewer | No | Yes | No | No |
| Approver/Manager | No | Yes | Yes | No |
| Program Admin | No | Optional | Optional | Yes |

### SLA targets
- Initial review response: within 5 business days.
- Re-review after `needs_update`: within 3 business days.
- Promotion decision after all criteria approved: within 2 business days.

## 3) Rollback and reopen policy for contested promotions
- Use rollback only when a promotion decision is found incorrect or policy-noncompliant.
- Rollback must include:
  - `rollback=true` in promotion event
  - non-empty reason
  - approver identity
- Reopen flow:
  1. Record rollback event.
  2. Set affected criteria status to `needs_update` or `in_review`.
  3. Submit updated evidence.
  4. Run normal review and promotion flow.

## 4) Audit and retention
- Event logs are append-only JSONL.
- Do not delete historical review or promotion events.
- Corrections are represented as new events, not edits to old events.

## 5) Data handling constraints
- Do not store secrets, credentials, or customer PII in evidence text fields.
- Use links/references to controlled systems where sensitive data is required.
