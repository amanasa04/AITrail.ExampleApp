# Feature Spec: Rubric v2 Criteria Alignment

## Metadata
- Spec ID: rubric-v2-criteria-alignment
- Date: 2026-06-08
- Status: Draft
- Owner: AI Trail Program Owners / Engineering Enablement Lead
- Source baseline: `AI-Trail-Progression-Summary.md` (authoritative operational rubric) vs `tracking/rubric/rubric.v1.json` (current active rubric)

## Problem statement
`rubric.v1.json` was initially inferred from the AI-First SDLC program guidance. The `AI-Trail-Progression-Summary.md` document now provides the authoritative operational level model with explicit intent, capabilities, and evidence requirements for each of the four AI Trail levels. Gaps exist between the v1 rubric criteria and the progression summary's full evidence set. These gaps mean engineers and reviewers may be evaluated against an incomplete or misaligned rubric.

## Goals
- Align `rubric.v1.json` criteria exactly with the evidence requirements stated in `AI-Trail-Progression-Summary.md`.
- Produce a version-bumped `rubric.v2.json` that becomes the new active rubric.
- Update `CHANGELOG.md` to document all additions, removals, and changes.
- Ensure no breaking changes to `validate.ps1` or existing progress files during the transition.
- Establish the rubric-v2 as the canonical reference for all future badge promotions.

## Non-goals
- Modifying the JSON schema for rubric structure (schema must remain backward-compatible).
- Changing the validation script logic in `validate.ps1` (schema-level only, no script changes in this spec).
- Updating existing engineer progress files to v2 rubric (a separate migration task if needed).
- Adding new levels beyond the four defined in the progression summary.

## Personas
- **Program Admin:** Needs the rubric to exactly reflect the official criteria so review decisions are defensible.
- **Engineer/Participant:** Needs criteria descriptions that match what they were coached on, so evidence preparation is unambiguous.
- **Reviewer/Coach:** Needs consistent, complete criterion descriptions to evaluate evidence fairly across engineers.

## Scope (v2 rubric)

### Level 1 — Environment and Instruction Foundations
**Intent (from progression summary):** Engineer can prepare a compliant AI-agent development environment.

| Criterion ID | v1 description | v2 description (from progression summary) | Change |
|---|---|---|---|
| L1-C1 | Base instructions file present and reviewed | `copilot-instructions.md` present and reviewed | Clarified — add file name |
| L1-C2 | Workspace setup rationale documented | Workspace setup decision documented (repo vs multi-repo + rationale) | Clarified — add decision framing |
| L1-C3 | Toolkit configured and verified | Proof of toolkit initialization in repo history or setup notes | Clarified — add evidence form |
| L1-C4 | _(missing in v1)_ | Conditional instruction files (if applicable) created and referenced | **ADD** — optional criterion |

### Level 2 — Spec-Driven Planning Practitioner
**Intent (from progression summary):** Engineer can create durable agent context and planning artifacts before coding.

| Criterion ID | v1 description | v2 description (from progression summary) | Change |
|---|---|---|---|
| L2-C1 | Product context spec created or refreshed | Product/codebase spec artifacts exist (e.g. under `.agent-os/`) | Clarified — add path example |
| L2-C2 | Feature spec approved | Feature specification artifacts exist for in-flight work | Clarified — scope to in-flight |
| L2-C3 | Technical spec reviewed | Technical implementation approach documented and reviewed | Clarified — add "documented" |
| L2-C4 | _(missing in v1)_ | Spec revisions recorded after human review feedback | **ADD** — required criterion |

### Level 3 — Controlled Agent Execution
**Intent (from progression summary):** Engineer can run iterative agent implementation safely and effectively.

| Criterion ID | v1 description | v2 description (from progression summary) | Change |
|---|---|---|---|
| L3-C1 | Task list created with granular sequencing | Task plan file(s) with progress updates and issue notes | Clarified — add updates/notes |
| L3-C2 | Execution tracked with checkpoints | Execution logs showing iterative completion and review checkpoints | Clarified — add "iterative" |
| L3-C3 | _(need to confirm v1 text)_ | Commits reflecting small-batch implementation and recoverability | Clarified or add |
| L3-C4 | _(need to confirm v1 text)_ | AI attribution/tagging evidence where applicable | Clarified or add |

### Level 4 — Quality, Security, and Governance Operator
**Intent (from progression summary):** Engineer consistently governs AI-assisted delivery to production standards.

| Criterion ID | v1 description | v2 description (from progression summary) | Change |
|---|---|---|---|
| L4-C1 | _(from v1)_ | Validation proof: successful build/test checkpoints and acceptance mapping | Clarified |
| L4-C2 | _(from v1)_ | Security review notes for dependency additions and sensitive code paths | Clarified |
| L4-C3 | _(from v1)_ | Evidence of code review feedback cycles and refactoring outcomes | Clarified |
| L4-C4 | _(from v1)_ | Demonstrated adherence to policy constraints (no secrets/PII in prompts, etc.) | Clarified or add |

## Functional requirements

1. **Rubric v2 file** — `tracking/rubric/rubric.v2.json` shall contain all four levels with criteria updated per the progression summary alignment table above.
2. **Version field** — `rubric.v2.json` shall set `"version": "2.0.0"` and `"effective_from": "2026-06-08"`.
3. **Old rubric preserved** — `rubric.v1.json` shall remain untouched; `rubric.v2.json` is additive.
4. **Active status** — `rubric.v2.json` shall have `"status": "active"`; `rubric.v1.json` shall be updated to `"status": "superseded"`.
5. **CHANGELOG update** — `tracking/rubric/CHANGELOG.md` shall receive an entry documenting every criterion added, changed, or removed with rationale referencing the progression summary.
6. **Schema compatibility** — `rubric.v2.json` shall pass validation against `tracking/schema/rubric.schema.json` with no schema changes required.
7. **validate.ps1 pass** — `validate.ps1` must exit 0 after the rubric update with no modifications to the script.

## Acceptance criteria
1. `rubric.v2.json` exists in `tracking/rubric/` and is valid JSON.
2. Running `validate.ps1` exits 0.
3. All four levels in `rubric.v2.json` have criterion descriptions that match the intent and evidence requirements in `AI-Trail-Progression-Summary.md`.
4. No criteria present in `rubric.v1.json` have been silently removed — all must appear in v2 (possibly with updated descriptions).
5. `CHANGELOG.md` has a dated entry for the v2 release listing all changes.
6. `rubric.v1.json` `"status"` field reads `"superseded"`.
