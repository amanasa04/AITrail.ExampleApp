# Task 1 Implementation Artifacts

This folder contains executable and reviewable artifacts for Task 1:

- tests/task1-foundation.tests.ps1
  - Validates role policy coverage, required schema contracts, and migration content.
- sql/001_dynamic_team_manager_foundation.sql
  - SQL Server foundation migration for Employees, Teams, TeamMemberships, and AuditLogs.
- auth/role-policy-map.json
  - Entra ID / Easy Auth role-to-policy mapping contract.
- contracts/error-envelope.schema.json
  - Shared API error envelope schema.
- contracts/request-correlation-and-audit.md
  - Request correlation and audit middleware behavior contract.

## Run tests

From AITrail.ExampleApp:

powershell -ExecutionPolicy Bypass -File .agent-os/specs/2026-06-09-dynamic-team-manager-mvp/implementation/task-1/tests/task1-foundation.tests.ps1
