# Product Analysis

_Last refreshed: 2026-06-08_

## Product summary
`AITrail.ExampleApp` is a **documentation + file-driven tracking repository** for the Paycor **AI Trail** program. It is not an executable application/service codebase.

It serves two purposes:
1. **Program documentation** — a static export of the SharePoint page "AI-First SDLC" defining the agentic development process, approved tools/models, and spec-driven workflow.
2. **Progress tracking system** — a file-first, PowerShell-validated system under `tracking/` that records each engineer's progression through the four AI Trail badges (Greenhorn → Wayfinder → Trail Guide → Pioneer).

## Repository structure (relevant)
```
AITrail.ExampleApp/
├── AI-First SDLC.html                  # Canonical SharePoint export (noisy; prefer decoded files)
├── AI-First SDLC_files/                # Minified SharePoint JS/CSS bundles — DO NOT scan
├── _decoded_ai_sdlc_sections.txt       # PREFER: section-based extraction for semantic analysis
├── _decoded_ai_sdlc_text.txt           # Derived plain-text extraction
├── AI-Trail-Progression-Summary.md     # Level rubric summary (derived)
├── AI-Trail-Badge-Progression.md       # Official badge criteria from program slide deck
├── README.md                           # Placeholder
├── docs/                               # Slide images (Slide1–9.jpg)
├── .agent-os/
│   ├── product/analyze-product.md      # This file — product analysis and agent guidance
│   └── specs/
│       └── 2026-06-04-ai-trail-progress-tracking/
│           ├── README.md
│           ├── feature-spec.md
│           ├── technical-spec.md
│           └── tasks.md
├── .github/
│   ├── copilot-instructions.md         # Global repo instructions for Copilot Agent
│   ├── instructions/                   # Enforced coding instruction files
│   │   ├── ai-attribution.instructions.md
│   │   ├── api-standards.instructions.md
│   │   ├── clean-code.instructions.md
│   │   ├── code-modification-policy.instructions.md
│   │   └── critical-rules.instructions.md
│   ├── agents/                         # Agent definition files
│   │   ├── create-copilot-instructions.agent.md
│   │   ├── generate-repo-summary.agent.md
│   │   └── spec-and-execute.agent.md
│   └── prompts/                        # Slash-prompt files
│       ├── analyze-product.prompt.md
│       ├── create-spec.prompt.md
│       ├── execute-task.prompt.md
│       ├── execute-tasks.prompt.md
│       ├── plan-product.prompt.md
│       ├── 1-generate-repo-summary.prompt.md
│       └── 2-create-copilot-instructions.prompt.md
└── tracking/                           # File-driven AI Trail progress tracking system
    ├── rubric/
    │   ├── rubric.v1.json              # L1–L4 level/criteria definitions (versioned)
    │   └── CHANGELOG.md               # Always update when editing rubric
    ├── schema/                         # JSON schemas for rubric, progress, evidence, events
    ├── progress/                       # One JSON file per engineer (e.g. sample-user.json)
    ├── events/
    │   ├── review-events.jsonl         # Append-only review decision log
    │   └── promotion-events.jsonl      # Append-only promotion log
    ├── reports/                        # Generated CSV reports (do not hand-edit)
    ├── scripts/
    │   ├── validate.ps1                # Schema + workflow validation
    │   └── generate-reports.ps1        # CSV report generation
    ├── governance.md                   # Role matrix, SLAs, rollback/reopen policy
    └── README.md                       # Operational runbook
```

## Technology/runtime profile
- Content type: documentation HTML export + file-driven JSON/JSONL data store.
- Languages present: HTML/CSS/JavaScript (minified SharePoint payload), Markdown, JSON, JSONL, PowerShell.
- Build tooling: none (no compile step, no npm, no dotnet, no package.json).
- Dependency manifests: none.
- Runnable artifacts: PowerShell scripts only (`tracking/scripts/`).
- CI/test setup: manual validation via PowerShell; no automated CI pipeline.

## Architecture and content model

### 1) Canonical content source
The canonical program documentation is embedded inside `AI-First SDLC.html` as encoded page JSON (`CanvasContent1`).
Prefer `_decoded_ai_sdlc_sections.txt` for analysis — it is the low-noise derived extraction.

### 2) Badge/level model
Four badges defined in `AI-Trail-Badge-Progression.md` (sourced from official slide deck):
- **Greenhorn** — onboarding; tools installed; training complete.
- **Wayfinder** — independent AI-effective usage without quality compromise.
- **Trail Guide** — coaches individuals/teams.
- **Pioneer** — establishes new techniques that become standards.

Level criteria are encoded in `tracking/rubric/rubric.v1.json`.

### 3) Progress tracking data flow
```
Engineer JSON (progress/)  →  validate.ps1 (schema + workflow rules)
                           →  generate-reports.ps1 (→ reports/ CSV)
Review/Promotion decisions → events/review-events.jsonl (append-only)
                           → events/promotion-events.jsonl (append-only)
```

Validation rules enforced:
- All JSON/JSONL must match schema.
- Rejected or `needs_update` reviews must include a comment.
- Promotion transitions must be monotonic (unless `rollback: true`).
- Promotion to a level requires all required target-level criteria approved.

### 4) Agent tooling scaffold
A full spec-driven Agent OS scaffold is present:
- `.github/copilot-instructions.md` — authoritative repo context for the agent.
- `.github/instructions/` — enforced global coding instructions (attribution, API standards, clean code, modification policy, critical rules).
- `.github/agents/` — named agent definitions.
- `.github/prompts/` — slash-prompt files for `/analyze-product`, `/create-spec`, `/execute-tasks`, etc.
- `.agent-os/specs/` — spec packages (feature + technical + tasks per feature).

## Build/run/test commands
Run all commands from the `tracking/` directory:

```powershell
# Validate schemas and workflow rules
cd AITrail.ExampleApp\tracking
powershell -ExecutionPolicy Bypass -File .\scripts\validate.ps1

# Generate CSV reports
powershell -ExecutionPolicy Bypass -File .\scripts\generate-reports.ps1
```

> Note: scripts use `$MyInvocation.MyCommand.Path` internally and must be invoked as a `.ps1` file (not as a scriptblock). Exit code `-1073740791` may appear intermittently in nested PowerShell invocations; artifact timestamp checks are a reliable validation fallback.

Commands documented inside the program content (for *external* codebases, not this repo):
- `npx @paycor/ai-sdlc-toolkit`
- `npm install -g @paycor/ai-sdlc-toolkit`
- `create-ai-sdlc`

## Agent-operational guidance for this repo
- Treat `_decoded_ai_sdlc_sections.txt` as the primary semantic source for program content. Avoid broad scans of `AI-First SDLC_files/`.
- `copilot-instructions.md` is the authoritative context file; trust it first before searching the codebase.
- For updates to deliverables, derive from: `AI-First SDLC.html` → `_decoded_ai_sdlc_sections.txt` → existing markdown artifacts.
- When editing `rubric.v1.json`, always update `rubric/CHANGELOG.md`.
- Event log files (`*.jsonl`) are append-only; never delete or rewrite existing entries.
- Specs live in `.agent-os/specs/<date>-<slug>/` following the pattern: `README.md`, `feature-spec.md`, `technical-spec.md`, `tasks.md`.

## Risks and constraints
- SharePoint-export HTML is noisy; use decoded section files for semantic work.
- Content may contain HTML-decode artifacts (entity remnants, spacing anomalies).
- No CI pipeline — validation is manual; humans must remember to run `validate.ps1`.
- Progress/event data must remain free of secrets and PII.

## Gaps found
- No automated CI trigger for `validate.ps1` (e.g. GitHub Actions).
- `rubric.v1.json` level criteria were inferred from program docs; confirm against official owner-approved rubric if one exists.
- `docs/` contains only slide images with no accompanying text — consider adding captions/alt-text for searchability.

## Recommended next actions
1. Wire `validate.ps1` into a GitHub Actions workflow on push to enforce data integrity automatically.
2. Confirm `rubric.v1.json` criteria with AI Trail program owners and version-bump to `rubric.v2.json` if changes are made.
3. Add alt-text or a `docs/README.md` describing what each slide image covers.
