# Feature Spec: AI Trail Individual Progress Tracking System

## Metadata
- Spec ID: ai-trail-progress-tracking
- Date: 2026-06-04
- Status: Draft
- Owner: Enterprise Architecture / AI Trail Program
- Source baseline: AI-First SDLC guidance and derived operational level rubric

## Problem statement
The AI Trail guidance defines goals and practices, but teams need a consistent way to track each engineer's progression, evidence submissions, and promotion readiness across trail levels. Current state is mostly document-driven and ad hoc, which makes comparisons, approvals, and auditability difficult.

## Goals
- Track individual progress against AI Trail levels and advancement criteria.
- Standardize evidence capture and review/approval decisions.
- Provide visibility into readiness, blockers, and completion by person/team.
- Preserve an auditable history of evidence and level changes.

## Non-goals
- Replace engineering code review systems.
- Replace HR systems of record.
- Auto-evaluate code quality from source repositories in v1.

## Personas
- Engineer: submits evidence and monitors level progress.
- Reviewer/Manager: validates evidence, requests changes, approves level advancement.
- Program Admin: configures rubric definitions, reporting dimensions, and governance rules.

## Scope (v1)
- Manage rubric levels and criteria (configurable, versioned).
- Create and manage individual progress records.
- Collect evidence linked to criteria.
- Review workflow with decisions: approved, rejected, needs-update.
- Level promotion workflow with rationale and approver attribution.
- Dashboard/report exports (team-level and individual-level views).

## Functional requirements
1. Rubric management
- System shall store levels, criteria, and evidence requirements as structured data.
- System shall support rubric versioning and effective dates.
- System shall allow explicit mapping of criteria to advancement gates.

2. Individual profile and progress
- System shall maintain one progress record per user per rubric version.
- System shall show current level, target level, and criteria completion status.
- System shall calculate readiness state: not started, in progress, review ready, promoted.

3. Evidence capture
- System shall support multiple evidence items per criterion.
- Evidence types: document link, repo/spec link, checklist confirmation, reviewer notes.
- Each evidence item shall include submitter, timestamp, and status.

4. Review and approval workflow
- Reviewers shall be able to approve/reject/request changes for each criterion.
- System shall require reviewer comments for rejection/changes requested.
- System shall require a promotion decision record when all required criteria are approved.

5. Promotion and history
- System shall record level changes as immutable timeline events.
- History entries shall include who approved, when, and why.
- System shall support rollback/reopen with reason and actor attribution.

6. Reporting
- System shall provide individual readiness view.
- System shall provide team view by level distribution and review bottlenecks.
- System shall export progress and evidence metadata to CSV.

## Data model (conceptual)
- Rubric
  - rubric_id, name, version, effective_from, effective_to, status
- Level
  - level_id, rubric_id, name, sequence
- Criterion
  - criterion_id, level_id, description, required_boolean, evidence_type, gate_weight
- UserProgress
  - progress_id, user_id, rubric_id, current_level_id, target_level_id, readiness_state
- Evidence
  - evidence_id, progress_id, criterion_id, type, uri_or_text, submitted_by, submitted_at, status
- ReviewDecision
  - decision_id, evidence_id or criterion_id, reviewer_id, decision, comment, decided_at
- PromotionEvent
  - event_id, progress_id, from_level_id, to_level_id, approver_id, reason, decided_at

## Acceptance criteria
1. Given a user with no record, when admin assigns rubric, then a new progress record is created with level 1 as current and readiness not started.
2. Given a criterion with required evidence, when engineer submits evidence, then criterion status moves to in review.
3. Given reviewer rejects evidence, when rejection is saved, then reviewer comment is mandatory and criterion stays incomplete.
4. Given all required criteria approved for next level, when approver promotes, then promotion event is recorded and current level updates.
5. Given team manager opens dashboard, then they can filter by team and view level distribution and pending reviews.

## Risks
- Ambiguity in official level definitions may create inconsistent decisions.
- Manual evidence review may become a bottleneck.
- Rubric changes over time can affect comparability if versioning is not enforced.

## Open questions
- Source of truth for organization hierarchy/team membership?
- Required SLA for evidence review turnaround?
- Should evidence links enforce access validation?
- What fields are mandatory for audit/compliance?

## Success metrics
- >=90% of active participants have complete progress records.
- <7 days median review cycle time per criterion.
- >=95% of promotions have complete evidence and decision trail.
- Reduction in manual status-tracking effort reported by managers.
