# Task 2 Implementation Artifacts

This folder contains implementation scaffolding and tests for Task 2.

## Included files

- src/TeamsController.cs
  - Teams endpoints and policy annotations.
- src/TeamMembershipsController.cs
  - Membership endpoints and policy annotations.
- src/AuditContracts.cs
  - Shared audit writer and event factory contract.
- contracts/endpoint-matrix.md
  - Endpoint, policy, and behavior matrix.
- tests/task2-api.tests.ps1
  - Validates endpoint coverage, policy coverage, and write-audit behavior.

## Run tests

From AITrail.ExampleApp:

powershell -ExecutionPolicy Bypass -File .agent-os/specs/2026-06-09-dynamic-team-manager-mvp/implementation/task-2/tests/task2-api.tests.ps1
