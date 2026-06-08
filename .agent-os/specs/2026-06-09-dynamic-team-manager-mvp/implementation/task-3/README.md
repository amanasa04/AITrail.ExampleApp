# Task 3 Implementation Artifacts

This folder contains frontend scaffolding for team and roster management workflows.

## Included files

- tests/task3-frontend.tests.ps1
  - Validates React Query hooks and required UI behavior markers.
- src/types.ts
  - Shared frontend types for team and membership data models.
- src/api/client.ts
  - API helper and query string utility.
- src/api/teams.ts
  - React Query service layer for teams and memberships.
- src/pages/TeamListPage.tsx
  - Team list, create, rename, archive, and filters.
- src/pages/TeamDetailPage.tsx
  - Roster view with role and active filters.
- src/components/MembershipEditorDialog.tsx
  - Membership add/edit dialog with employee lookup, role, and effective dates.

## Run tests

From AITrail.ExampleApp:

powershell -ExecutionPolicy Bypass -File .agent-os/specs/2026-06-09-dynamic-team-manager-mvp/implementation/task-3/tests/task3-frontend.tests.ps1
