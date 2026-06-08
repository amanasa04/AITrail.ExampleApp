# Spec Package: Rubric v2 Criteria Alignment

## Files
- `feature-spec.md`: business requirements, acceptance criteria, and alignment gaps between rubric.v1.json and the authoritative progression summary.
- `technical-spec.md`: implementation contracts — rubric.v2.json schema additions, CHANGELOG update rules, and validation impact.
- `tasks.md`: executable work breakdown.

## Context
This spec package is derived from:
- `AI-Trail-Progression-Summary.md` — authoritative operational level model and evidence requirements (primary source).
- `tracking/rubric/rubric.v1.json` — current active rubric (baseline to compare against).
- `tracking/rubric/CHANGELOG.md` — versioning history (must be updated as part of this work).
- `tracking/schema/` — JSON schemas that constrain rubric structure (must remain valid after update).
- `.agent-os/product/roadmap.md` — Phase 1 item: "Rubric v2 Review" (`M` effort).

## Intended next command
- Execute `/execute-tasks` using this folder as the active spec context.
