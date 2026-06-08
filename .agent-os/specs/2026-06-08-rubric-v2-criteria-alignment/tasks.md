# Tasks: Rubric v2 Criteria Alignment

## Phase 1 - Schema readiness
1. [x] Read `tracking/schema/rubric.schema.json` and verify it permits required fields.
   - Findings: three schema fixes required (see task 2).
2. [x] Update `rubric.schema.json` with the following additive fixes:
   - Add `"superseded"` to `status` enum (was `["draft","active","retired"]`).
   - Add optional `"supersedes"` string property at root level and remove root `additionalProperties: false` (or allow it).
   - Change `gate_weight` minimum from `1` to `0` to allow non-gating criteria (L1-C4).

## Phase 2 - Produce rubric.v2.json
3. [x] Create `tracking/rubric/rubric.v2.json` as a copy of `rubric.v1.json` with the following changes applied per `technical-spec.md`:
   - Set `"version": "2.0.0"`, `"effective_from": "2026-06-08"`, `"status": "active"`.
   - Add `"supersedes": "1.0.0"` at the top level.
   - Apply all clarified descriptions for L1-C1 through L4-C3.
   - Add L1-C4 (`required: false`, `gate_weight: 0`).
   - Add L2-C4 (`required: true`, `gate_weight: 1`).
   - Add L3-C4 (`required: true`, `gate_weight: 1`).
   - Add L4-C4 (`required: true`, `gate_weight: 1`).

## Phase 3 - Mark v1 as superseded
4. [x] In `tracking/rubric/rubric.v1.json`, change `"status": "active"` → `"status": "superseded"`. No other changes.

## Phase 4 - Update CHANGELOG
5. [x] Prepend the `[2.0.0] - 2026-06-08` entry to `tracking/rubric/CHANGELOG.md` exactly as specified in `technical-spec.md`.

## Phase 5 - Validation
6. [x] Run `validate.ps1` from `tracking/` and confirm exit 0:
   ```powershell
   cd AITrail.ExampleApp\tracking
   powershell -ExecutionPolicy Bypass -File .\scripts\validate.ps1
   ```
7. [x] Visually confirm `rubric.v2.json` has:
   - Exactly 4 levels.
   - L1: 4 criteria (L1-C1 through L1-C4).
   - L2: 4 criteria (L2-C1 through L2-C4).
   - L3: 4 criteria (L3-C1 through L3-C4).
   - L4: 4 criteria (L4-C1 through L4-C4).

## Validation checklist
- [x] `rubric.v2.json` is valid JSON and passes schema validation.
- [x] `validate.ps1` exits 0 after changes.
- [x] All criteria descriptions match language from `AI-Trail-Progression-Summary.md`.
- [x] No criteria from v1 were silently removed.
- [x] `rubric.v1.json` `"status"` reads `"superseded"`.
- [x] `CHANGELOG.md` has a dated `[2.0.0]` entry.

## Suggested task execution order
- Execute tasks 1-2 first (schema readiness before creating the new rubric).
- Execute task 3 (create rubric.v2.json).
- Execute task 4 (mark v1 superseded).
- Execute task 5 (update CHANGELOG).
- Execute tasks 6-7 (validate).

## Notes
- Do not delete `rubric.v1.json` — it must be preserved as a historical artifact.
- Do not modify existing progress files in `tracking/progress/` — they reference `rubric_id: "ai-trail"` not a version field; the version bump is non-breaking for existing records.
- All criterion descriptions must remain ASCII; no special characters.
- Source of truth for all v2 descriptions: `AI-Trail-Progression-Summary.md` (evidence requirement bullets under each level).
