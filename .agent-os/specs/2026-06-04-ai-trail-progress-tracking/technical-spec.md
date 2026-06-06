# Technical Spec: AI Trail Individual Progress Tracking System

## Metadata
- Spec ID: ai-trail-progress-tracking-tech
- Date: 2026-06-04
- Status: Draft
- Depends on: feature-spec.md

## Implementation approach
Because this repository is documentation-focused and not an application codebase, v1 should be delivered as a lightweight, file-driven system that can be operated immediately and later migrated to a service-backed app.

### Proposed v1 architecture (file-first)
- Storage format:
  - `rubric.json` for level/criteria definitions
  - `progress/*.json` one file per user progress record
  - `events/*.jsonl` append-only promotion/review event streams
- Reporting:
  - generated `reports/*.csv` artifacts for team dashboards
- Validation:
  - JSON Schema for rubric/progress/evidence structures
- Automation:
  - scripted validators and report generation via PowerShell or Node script

### Proposed v2 architecture (service-backed, future)
- UI: web app for engineer/reviewer workflows
- API: CRUD + workflow endpoints
- DB: relational storage with audit tables
- Auth: enterprise SSO + role mapping

## Repository layout (proposed)
- `.agent-os/specs/2026-06-04-ai-trail-progress-tracking/`
- `tracking/rubric/rubric.v1.json`
- `tracking/progress/{user_id}.json`
- `tracking/events/review-events.jsonl`
- `tracking/events/promotion-events.jsonl`
- `tracking/reports/{date}-team-summary.csv`
- `tracking/schema/*.schema.json`
- `tracking/scripts/validate.ps1`
- `tracking/scripts/generate-reports.ps1`

## File contracts
1. Rubric
- unique rubric id and semantic version
- ordered levels
- criteria with required flags and evidence types

2. User progress
- user metadata
- current/target level
- criterion status map
- linked evidence references

3. Events
- append-only lines with event_type, actor, timestamp, payload
- immutable once written

## Workflow design
1. Admin updates rubric version.
2. Engineer submits evidence to progress file.
3. Reviewer records decision event and updates criterion status.
4. Approver records promotion event.
5. Report script computes readiness and exports summaries.

## Validation rules
- No promotion event allowed unless all required criteria approved.
- Evidence entry must include criterion_id, submitter, timestamp.
- Rejection decision must include non-empty comment.
- Level transitions must be monotonic unless rollback flag and reason provided.
- Progress file rubric_version must match an existing rubric file.

## Security and governance
- No credentials, tokens, or PII in free-text evidence fields.
- Enforce role-based write permissions by folder:
  - engineers: own progress evidence append
  - reviewers: decision updates
  - admins: rubric changes
- Maintain append-only event logs for auditability.

## Operational requirements
- Validation script must fail with non-zero exit code on schema/workflow violations.
- Report generation script must produce deterministic output for same input.
- Scripts should run in Windows PowerShell environment available in this workspace.

## Migration plan (v1 -> v2)
- Keep stable data contract fields between file-based and DB models.
- Build import tool from json/jsonl into relational schema.
- Preserve event ids and timestamps during migration.

## Risks and mitigations
- Risk: merge conflicts on shared files.
  - Mitigation: one-file-per-user progress, append-only logs.
- Risk: manual editing errors.
  - Mitigation: schema validation and CI checks when available.
- Risk: rubric drift.
  - Mitigation: strict version pinning per progress record.

## Definition of done
- Rubric file and schemas exist and validate.
- At least one sample user progress file validates.
- Review and promotion events can be recorded and validated.
- Report generation script outputs team and individual summaries.
- Documentation explains how to operate the workflow end-to-end.
