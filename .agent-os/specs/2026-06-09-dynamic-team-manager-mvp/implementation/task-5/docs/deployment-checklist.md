# Deployment Checklist

## Pre-deploy

- [ ] Confirm task-level tests pass for tasks 1 through 5.
- [ ] Confirm tracking validation script passes.
- [ ] Confirm performance validation report status is Passed.
- [ ] Confirm e2e validation report status is Passed.
- [ ] Confirm migration script reviewed by DBA.

## Deploy to dev

- [ ] Deploy API and frontend artifacts to development environment.
- [ ] Execute smoke tests for team create, roster search, and CSV export.
- [ ] Confirm audit entries emitted for write operations.

## Promote to test

- [ ] Run role-based access checks for Employee, TeamEditor, HRAnalyst, Admin.
- [ ] Validate team-size and membership-trend report endpoints.
- [ ] Validate CSV export filtered parity with search endpoint.

## Promote to production

- [ ] Obtain stakeholder approval from HR and operations owner.
- [ ] Deploy through standard pipeline with approved change window.
- [ ] Run post-deploy smoke and monitoring checks.
- [ ] Publish runbook and support escalation references.
