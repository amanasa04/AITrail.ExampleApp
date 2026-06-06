# AI Trail Tracking (v1, file-first)

This folder contains a lightweight, file-driven implementation of the AI Trail progress tracking system.

## Structure
- rubric
  - rubric.v1.json
  - CHANGELOG.md
- schema
  - rubric.schema.json
  - progress.schema.json
  - evidence.schema.json
  - review-event.schema.json
  - promotion-event.schema.json
- progress
  - sample-user.json
- events
  - review-events.jsonl
  - promotion-events.jsonl
- scripts
  - validate.ps1
  - generate-reports.ps1
- governance.md
- reports
  - generated CSV output files

## How to run
From this folder:

1. Validate schema and workflow rules
- powershell -ExecutionPolicy Bypass -File .\scripts\validate.ps1

2. Generate reports
- powershell -ExecutionPolicy Bypass -File .\scripts\generate-reports.ps1

## Validation rules enforced
- All JSON and JSONL event lines must match schema.
- Rejected or needs_update review decisions must include comment.
- Promotion transitions must be monotonic unless rollback is true.
- Promotion to a level requires all required target-level criteria approved.

## Notes
- Event logs are append-only JSONL files.
- Keep sample and operational data free of secrets and PII.
- Use rubric version pinning in each progress record.
- Governance policy, role matrix, SLA, and rollback rules are in `tracking/governance.md`.
