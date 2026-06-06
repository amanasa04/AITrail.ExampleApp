# AI Trail Program Summary (from available documents)

## Scope and source notes
- Primary source analyzed: `AITrail.ExampleApp/AI-First SDLC.html` (decoded from embedded SharePoint page content).
- Supplemental files in this workspace did not contain additional AI Trail level criteria.
- The source content defines goals, practices, and a workflow (`Step 1` and `Step 2`), but does **not** provide an explicit official "Level 1/2/3" trail rubric.
- Because you requested levels and advancement evidence for tracking, the level model below is a **proposed operational rubric** mapped directly to the source guidance.

## Program goals captured from the documents
The program is aimed at an AI-first, agentic SDLC that:
- Accelerates delivery of functional, quality code.
- Uses AI across the full lifecycle: design, code development, testing/validation, and infrastructure/observability.
- Improves code quality through iterative agent workflows, clear instructions, and specification-driven development.
- Strengthens reliability and governance via validation, security checks, code review, and accountability.

### Goal areas called out in the source
- **Design**
  - AI-first planning/design
  - AI-powered database design and optimization
- **Code Development**
  - AI-driven code changes for features, bug fixes, spikes, and maintenance
  - High percentage of AI-generated new code
  - AI-enabled maintenance/refactoring
  - AI-assisted code reviews
  - AI-powered security validation
  - Automated code documentation
- **Testing/Validation**
  - Comprehensive AI-generated test coverage
  - AI validation against acceptance criteria
  - AI-driven performance testing
- **Infrastructure/Observability**
  - AI-generated infrastructure as code (IaC)
  - AI-generated observability and monitoring queries

## Proposed AI Trail levels for progress tracking

### Level 1 - Environment and Instruction Foundations
**Intent**: Engineer can prepare a compliant AI-agent development environment.

**Capabilities demonstrated**
- Uses approved tools/models for Paycor context.
- Sets up baseline repository/workspace instructions.
- Configures workspace correctly (single-repo or multi-repo as needed).
- Installs and verifies AI SDLC toolkit availability.

**Evidence required to advance to Level 2**
- `copilot-instructions.md` present and reviewed.
- Optional conditional instruction files (if applicable) are created and referenced.
- Workspace setup decision documented (repo vs multi-repo + rationale).
- Proof of toolkit initialization in repo history or setup notes.

---

### Level 2 - Spec-Driven Planning Practitioner
**Intent**: Engineer can create durable agent context and planning artifacts before coding.

**Capabilities demonstrated**
- Runs product/context analysis for existing or new codebases.
- Produces feature + technical specs for each change.
- Refines specs to reduce over-complexity and redundancy.

**Evidence required to advance to Level 3**
- Product/codebase spec artifacts exist (for example under `.agent-os/`).
- Feature specification artifacts exist for in-flight work.
- Technical implementation approach documented and reviewed.
- Spec revisions recorded after human review feedback.

---

### Level 3 - Controlled Agent Execution
**Intent**: Engineer can run iterative agent implementation safely and effectively.

**Capabilities demonstrated**
- Creates granular task breakdowns from approved specs.
- Executes tasks iteratively with regular checkpoints.
- Uses clear chat/task history hygiene (scope control, fresh threads where needed).
- Tags/attributes AI-generated output as required.

**Evidence required to advance to Level 4**
- Task plan file(s) with progress updates and issue notes.
- Execution logs showing iterative completion and review checkpoints.
- Commits reflecting small-batch implementation and recoverability.
- AI attribution/tagging evidence where applicable.

---

### Level 4 - Quality, Security, and Governance Operator
**Intent**: Engineer consistently governs AI-assisted delivery to production standards.

**Capabilities demonstrated**
- Enforces frequent compile/test/validation checks during execution.
- Performs explicit review of new libraries and package risk.
- Applies secure coding and data-handling constraints.
- Ensures test coverage and policy-compliant review before acceptance.

**Evidence required to maintain Level 4 (or mentor others)**
- Validation proof: successful build/test checkpoints and acceptance mapping.
- Security review notes for dependency additions and sensitive code paths.
- Evidence of code review feedback cycles and refactoring outcomes.
- Demonstrated adherence to policy constraints (no secrets/PII in prompts, etc.).

## Advancement checklist template (for individual tracking)
Use this per engineer per feature cycle.

- Level 1 complete:
  - [ ] Base instructions file present
  - [ ] Conditional instructions (if needed)
  - [ ] Workspace setup rationale documented
  - [ ] Toolkit configured and verified
- Level 2 complete:
  - [ ] Product/context spec created or refreshed
  - [ ] Feature spec approved
  - [ ] Technical spec reviewed
  - [ ] Spec quality refinements captured
- Level 3 complete:
  - [ ] Task list created with granular sequencing
  - [ ] Task execution tracked with checkpoints
  - [ ] Small-scope commit history present
  - [ ] AI attribution/tagging done where required
- Level 4 complete:
  - [ ] Build/test checks run iteratively
  - [ ] Dependency/security review completed
  - [ ] Code review findings addressed
  - [ ] Final validation against requirements recorded

## Gaps to close for an official trail rubric
To move from this operational rubric to an official program rubric, define:
- Official level names and count.
- Mandatory evidence artifacts per level.
- Promotion rules (who approves, what minimum evidence is required).
- Recertification cadence (if any) and regression handling.
