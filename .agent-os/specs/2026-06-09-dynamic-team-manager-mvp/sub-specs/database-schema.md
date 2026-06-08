# Database Schema

This is the database schema implementation for the spec detailed in .agent-os/specs/2026-06-09-dynamic-team-manager-mvp/spec.md

## Schema Changes

### New Table: Employees

```sql
CREATE TABLE dbo.Employees (
  EmployeeId            BIGINT         NOT NULL PRIMARY KEY,
  ExternalWorkerId      NVARCHAR(64)   NULL,
  FirstName             NVARCHAR(100)  NOT NULL,
  LastName              NVARCHAR(100)  NOT NULL,
  Email                 NVARCHAR(256)  NOT NULL,
  JobTitle              NVARCHAR(150)  NULL,
  Department            NVARCHAR(150)  NULL,
  Location              NVARCHAR(150)  NULL,
  ManagerEmployeeId     BIGINT         NULL,
  IsActive              BIT            NOT NULL DEFAULT 1,
  CreatedAtUtc          DATETIME2(0)   NOT NULL DEFAULT SYSUTCDATETIME(),
  UpdatedAtUtc          DATETIME2(0)   NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE UNIQUE INDEX UX_Employees_Email ON dbo.Employees (Email);
CREATE INDEX IX_Employees_LastName_FirstName ON dbo.Employees (LastName, FirstName);
```

### New Table: Teams

```sql
CREATE TABLE dbo.Teams (
  TeamId                BIGINT         IDENTITY(1,1) NOT NULL PRIMARY KEY,
  TeamCode              NVARCHAR(50)   NOT NULL,
  TeamName              NVARCHAR(150)  NOT NULL,
  OwnerEmployeeId       BIGINT         NULL,
  Department            NVARCHAR(150)  NULL,
  Status                NVARCHAR(20)   NOT NULL DEFAULT 'Active',
  CreatedBy             NVARCHAR(256)  NOT NULL,
  CreatedAtUtc          DATETIME2(0)   NOT NULL DEFAULT SYSUTCDATETIME(),
  UpdatedBy             NVARCHAR(256)  NOT NULL,
  UpdatedAtUtc          DATETIME2(0)   NOT NULL DEFAULT SYSUTCDATETIME(),
  CONSTRAINT CK_Teams_Status CHECK (Status IN ('Active','Archived')),
  CONSTRAINT UQ_Teams_TeamCode UNIQUE (TeamCode)
);

CREATE INDEX IX_Teams_TeamName ON dbo.Teams (TeamName);
CREATE INDEX IX_Teams_Status ON dbo.Teams (Status);
```

### New Table: TeamMemberships

```sql
CREATE TABLE dbo.TeamMemberships (
  TeamMembershipId      BIGINT         IDENTITY(1,1) NOT NULL PRIMARY KEY,
  TeamId                BIGINT         NOT NULL,
  EmployeeId            BIGINT         NOT NULL,
  TeamRole              NVARCHAR(50)   NOT NULL,
  EffectiveStartDate    DATE           NOT NULL,
  EffectiveEndDate      DATE           NULL,
  IsActive              AS (CASE WHEN EffectiveEndDate IS NULL OR EffectiveEndDate >= CAST(SYSUTCDATETIME() AS DATE) THEN 1 ELSE 0 END),
  CreatedBy             NVARCHAR(256)  NOT NULL,
  CreatedAtUtc          DATETIME2(0)   NOT NULL DEFAULT SYSUTCDATETIME(),
  UpdatedBy             NVARCHAR(256)  NOT NULL,
  UpdatedAtUtc          DATETIME2(0)   NOT NULL DEFAULT SYSUTCDATETIME(),
  CONSTRAINT FK_TeamMemberships_Teams FOREIGN KEY (TeamId) REFERENCES dbo.Teams (TeamId),
  CONSTRAINT FK_TeamMemberships_Employees FOREIGN KEY (EmployeeId) REFERENCES dbo.Employees (EmployeeId),
  CONSTRAINT CK_TeamMemberships_DateRange CHECK (EffectiveEndDate IS NULL OR EffectiveEndDate >= EffectiveStartDate)
);

CREATE INDEX IX_TeamMemberships_TeamId ON dbo.TeamMemberships (TeamId, EffectiveStartDate, EffectiveEndDate);
CREATE INDEX IX_TeamMemberships_EmployeeId ON dbo.TeamMemberships (EmployeeId, EffectiveStartDate, EffectiveEndDate);
CREATE INDEX IX_TeamMemberships_TeamRole ON dbo.TeamMemberships (TeamRole);
```

### New Table: AuditLogs

```sql
CREATE TABLE dbo.AuditLogs (
  AuditLogId            BIGINT         IDENTITY(1,1) NOT NULL PRIMARY KEY,
  EntityType            NVARCHAR(50)   NOT NULL,
  EntityId              NVARCHAR(100)  NOT NULL,
  Action                NVARCHAR(20)   NOT NULL,
  ChangedBy             NVARCHAR(256)  NOT NULL,
  ChangedAtUtc          DATETIME2(0)   NOT NULL DEFAULT SYSUTCDATETIME(),
  CorrelationId         NVARCHAR(100)  NULL,
  OldValuesJson         NVARCHAR(MAX)  NULL,
  NewValuesJson         NVARCHAR(MAX)  NULL
);

CREATE INDEX IX_AuditLogs_Entity ON dbo.AuditLogs (EntityType, EntityId, ChangedAtUtc DESC);
CREATE INDEX IX_AuditLogs_ChangedAtUtc ON dbo.AuditLogs (ChangedAtUtc DESC);
```

## Migration Notes

- Use idempotent migration scripts compatible with the standard deployment pipeline.
- Backfill Employees table from the approved internal employee source snapshot before enabling membership editing in production.
- Seed TeamRole reference values in application configuration for MVP: Manager, Lead, Member.

## Data Integrity Rules

- TeamCode must be unique and immutable once created.
- Team status supports soft lifecycle control (Active, Archived) without hard deleting historical memberships.
- Membership date ranges must be valid and non-inverted.
- Membership rows remain immutable for historical periods except corrective admin actions (captured in audit logs).

## Performance Considerations

- Roster and search operations rely on indexes for TeamName, Employee name fields, TeamId, EmployeeId, and TeamRole.
- Reporting queries should aggregate over effective-dated memberships using indexed date columns.
- AuditLogs growth should be monitored and partitioned by date if volume increases.
