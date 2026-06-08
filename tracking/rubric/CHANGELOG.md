# Rubric Change Log

## [2.0.0] - 2026-06-08
- Source: `AI-Trail-Progression-Summary.md` (authoritative operational rubric).
- Added L1-C4: Conditional instruction files (optional, non-gating; `required: false`, `gate_weight: 0`).
- Added L2-C4: Spec revisions recorded after review feedback (required, gating).
- Added L3-C4: Commits reflecting small-batch implementation and recoverability (required, gating).
- Added L4-C4: Demonstrated adherence to policy constraints (required, gating).
- Clarified L1-C1: "Base instructions file present and reviewed" → "copilot-instructions.md present and reviewed".
- Clarified L1-C2: added "repo vs multi-repo + rationale" decision framing.
- Clarified L1-C3: added "in repo history or setup notes" as evidence form.
- Clarified L2-C1: added ".agent-os/" path example.
- Clarified L2-C2: scoped to "in-flight work".
- Clarified L2-C3: added "documented and" before "reviewed".
- Clarified L3-C1: added "progress updates and issue notes".
- Clarified L3-C2: added "iterative" and expanded to "logs".
- Clarified L3-C3: "AI attribution evidence captured" → "AI attribution/tagging evidence where applicable".
- Changed L4-C1: "Iterative validation checks run and recorded" → "Validation proof: successful build/test checkpoints and acceptance mapping".
- Changed L4-C2: "Dependency and security review completed" → "Security review notes for dependency additions and sensitive code paths".
- Changed L4-C3: "Final acceptance mapping documented" → "Evidence of code review feedback cycles and refactoring outcomes" (acceptance mapping absorbed into L4-C1).
- Schema: added `"superseded"` to `status` enum; added optional `"supersedes"` root property; changed `gate_weight` minimum from 1 to 0.
- Marked `rubric.v1.json` status as `"superseded"`.

## [1.0.0] - 2026-06-04
- Initial published rubric for AI Trail progress tracking.
- Includes four levels (L1-L4) with required advancement criteria.
- Adds evidence types: `document_link`, `review_note`, `checklist`.
- Defines promotion gating prerequisites implemented in validation script.
