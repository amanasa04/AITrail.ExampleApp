# Technical Spec: Rubric v2 Criteria Alignment

## Metadata
- Spec ID: rubric-v2-criteria-alignment-tech
- Date: 2026-06-08
- Status: Draft
- Depends on: feature-spec.md

## Implementation approach
Produce `tracking/rubric/rubric.v2.json` by applying targeted criterion additions and description updates to the v1 content. Mark v1 as superseded. Update CHANGELOG. No changes to schema files, validation scripts, or progress data files.

---

## Exact criterion-level diff (v1 → v2)

### Level 1 — Environment and Instruction Foundations

| ID | v1 description | v2 description | Type |
|---|---|---|---|
| L1-C1 | Base instructions file present and reviewed | `copilot-instructions.md` present and reviewed | Clarify |
| L1-C2 | Workspace setup rationale documented | Workspace setup decision documented (repo vs multi-repo + rationale) | Clarify |
| L1-C3 | Toolkit configured and verified | Proof of toolkit initialization in repo history or setup notes | Clarify |
| L1-C4 | _(not in v1)_ | Conditional instruction files (if applicable) created and referenced | **Add** |

L1-C4 attributes: `"required": false`, `"evidence_type": "document_link"`, `"gate_weight": 0`

### Level 2 — Spec-Driven Planning Practitioner

| ID | v1 description | v2 description | Type |
|---|---|---|---|
| L2-C1 | Product context spec created or refreshed | Product/codebase spec artifacts exist (e.g. under `.agent-os/`) | Clarify |
| L2-C2 | Feature spec approved | Feature specification artifacts exist for in-flight work | Clarify |
| L2-C3 | Technical spec reviewed | Technical implementation approach documented and reviewed | Clarify |
| L2-C4 | _(not in v1)_ | Spec revisions recorded after human review feedback | **Add** |

L2-C4 attributes: `"required": true`, `"evidence_type": "review_note"`, `"gate_weight": 1`

### Level 3 — Controlled Agent Execution

| ID | v1 description | v2 description | Type |
|---|---|---|---|
| L3-C1 | Task list created with granular sequencing | Task plan file(s) with progress updates and issue notes | Clarify |
| L3-C2 | Execution tracked with checkpoints | Execution logs showing iterative completion and review checkpoints | Clarify |
| L3-C3 | AI attribution evidence captured | AI attribution/tagging evidence where applicable | Clarify |
| L3-C4 | _(not in v1)_ | Commits reflecting small-batch implementation and recoverability | **Add** |

L3-C4 attributes: `"required": true`, `"evidence_type": "document_link"`, `"gate_weight": 1`

### Level 4 — Quality, Security, and Governance Operator

| ID | v1 description | v2 description | Type |
|---|---|---|---|
| L4-C1 | Iterative validation checks run and recorded | Validation proof: successful build/test checkpoints and acceptance mapping | Clarify |
| L4-C2 | Dependency and security review completed | Security review notes for dependency additions and sensitive code paths | Clarify |
| L4-C3 | Final acceptance mapping documented | Evidence of code review feedback cycles and refactoring outcomes | **Change** |
| L4-C4 | _(not in v1)_ | Demonstrated adherence to policy constraints (no secrets/PII in prompts, etc.) | **Add** |

L4-C4 attributes: `"required": true`, `"evidence_type": "checklist"`, `"gate_weight": 1`

---

## rubric.v2.json file contract

```
tracking/rubric/rubric.v2.json
```

Top-level fields:
- `"rubric_id"`: `"ai-trail"` (unchanged)
- `"name"`: `"AI Trail Progression Rubric"` (unchanged)
- `"version"`: `"2.0.0"` (bumped from `"1.0.0"`)
- `"effective_from"`: `"2026-06-08"`
- `"status"`: `"active"`
- `"supersedes"`: `"1.0.0"` (new field — document lineage)
- `"levels"`: array of 4 levels with updated criteria per diff table above

Criterion object shape (unchanged from schema):
```json
{
  "criterion_id": "LN-CN",
  "description": "...",
  "required": true|false,
  "evidence_type": "document_link"|"review_note"|"checklist",
  "gate_weight": 0|1
}
```

---

## rubric.v1.json status update

Change only the `"status"` field:
```json
"status": "superseded"
```
No other changes to `rubric.v1.json`.

---

## CHANGELOG.md entry

Prepend a new entry at the top (below the header) following the existing format:

```markdown
## [2.0.0] - 2026-06-08
- Source: `AI-Trail-Progression-Summary.md` (authoritative operational rubric).
- Added L1-C4: Conditional instruction files (optional, non-gating).
- Added L2-C4: Spec revisions recorded after review feedback (required, gating).
- Added L3-C4: Commits reflecting small-batch implementation (required, gating).
- Added L4-C4: Policy constraint adherence (required, gating).
- Clarified descriptions for L1-C1 through L4-C3 to match progression summary evidence language.
- Changed L4-C3 from "Final acceptance mapping documented" to "Evidence of code review feedback cycles and refactoring outcomes" (acceptance mapping absorbed into L4-C1).
- Added `supersedes` field to top-level rubric object.
- Marked `rubric.v1.json` status as `"superseded"`.
```

---

## Schema compatibility check

`tracking/schema/rubric.schema.json` must be validated to confirm it allows:
1. An optional `"supersedes"` string field at the root level — add to schema if not present (additive, non-breaking).
2. `"required": false` on criteria — already used in v1 (`gate_weight: 0` pattern); confirm schema permits it.
3. Total criterion count per level is unconstrained — confirm schema has no `maxItems` on criteria array.

If any of the above are not permitted by the current schema, the schema must be updated first (additive change only — no removal of existing constraints).

---

## validate.ps1 impact

No logic changes required. `validate.ps1` validates JSON against schemas — the only requirement is that `rubric.v2.json` is valid per `rubric.schema.json`. The script does not hardcode level IDs or criterion counts.

Verify by running:
```powershell
cd AITrail.ExampleApp\tracking
powershell -ExecutionPolicy Bypass -File .\scripts\validate.ps1
```
Expected: exit 0 with no errors.

---

## External dependencies

None. No new libraries, packages, or tools required.
