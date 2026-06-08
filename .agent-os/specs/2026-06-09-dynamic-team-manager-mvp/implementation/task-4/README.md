# Task 4 Implementation Artifacts

This folder contains search, reporting, and CSV export implementation scaffolding.

## Included files

- tests/task4-search-report-export.tests.ps1
  - Verifies endpoint coverage, policy annotations, and CSV response behavior.
- src/QueryContracts.cs
  - Shared query and result models for search/report/export endpoints.
- src/SearchController.cs
  - Cross-team membership search endpoint.
- src/ReportsController.cs
  - Team-size and membership-trend reporting endpoints.
- src/ExportsController.cs
  - Membership CSV export endpoint and CSV writer helper.
- contracts/report-definitions.md
  - Report metrics definitions and aggregation rules.
- contracts/csv-export-columns.md
  - Export columns and permission rules.

## Run tests

From AITrail.ExampleApp:

powershell -ExecutionPolicy Bypass -File .agent-os/specs/2026-06-09-dynamic-team-manager-mvp/implementation/task-4/tests/task4-search-report-export.tests.ps1
