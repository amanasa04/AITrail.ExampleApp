/*
  Dynamic Team Manager MVP - Foundation Schema Migration
  Task 1.2 implementation artifact.
*/

IF OBJECT_ID('dbo.AuditLogs', 'U') IS NULL
BEGIN
  CREATE TABLE dbo.AuditLogs (
    AuditLogId       BIGINT        IDENTITY(1,1) NOT NULL PRIMARY KEY,
    EntityType       NVARCHAR(50)  NOT NULL,
    EntityId         NVARCHAR(100) NOT NULL,
    Action           NVARCHAR(20)  NOT NULL,
    ChangedBy        NVARCHAR(256) NOT NULL,
    ChangedAtUtc     DATETIME2(0)  NOT NULL DEFAULT SYSUTCDATETIME(),
    CorrelationId    NVARCHAR(100) NULL,
    OldValuesJson    NVARCHAR(MAX) NULL,
    NewValuesJson    NVARCHAR(MAX) NULL
  );

  CREATE INDEX IX_AuditLogs_Entity ON dbo.AuditLogs (EntityType, EntityId, ChangedAtUtc DESC);
END
GO

IF OBJECT_ID('dbo.Employees', 'U') IS NULL
BEGIN
  CREATE TABLE dbo.Employees (
    EmployeeId        BIGINT         NOT NULL PRIMARY KEY,
    ExternalWorkerId  NVARCHAR(64)   NULL,
    FirstName         NVARCHAR(100)  NOT NULL,
    LastName          NVARCHAR(100)  NOT NULL,
    Email             NVARCHAR(256)  NOT NULL,
    JobTitle          NVARCHAR(150)  NULL,
    Department        NVARCHAR(150)  NULL,
    Location          NVARCHAR(150)  NULL,
    ManagerEmployeeId BIGINT         NULL,
    IsActive          BIT            NOT NULL DEFAULT 1,
    CreatedAtUtc      DATETIME2(0)   NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAtUtc      DATETIME2(0)   NOT NULL DEFAULT SYSUTCDATETIME()
  );

  CREATE UNIQUE INDEX UX_Employees_Email ON dbo.Employees (Email);
  CREATE INDEX IX_Employees_LastFirst ON dbo.Employees (LastName, FirstName);
END
GO

IF OBJECT_ID('dbo.Teams', 'U') IS NULL
BEGIN
  CREATE TABLE dbo.Teams (
    TeamId            BIGINT         IDENTITY(1,1) NOT NULL PRIMARY KEY,
    TeamCode          NVARCHAR(50)   NOT NULL,
    TeamName          NVARCHAR(150)  NOT NULL,
    OwnerEmployeeId   BIGINT         NULL,
    Department        NVARCHAR(150)  NULL,
    Status            NVARCHAR(20)   NOT NULL DEFAULT 'Active',
    CreatedBy         NVARCHAR(256)  NOT NULL,
    CreatedAtUtc      DATETIME2(0)   NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedBy         NVARCHAR(256)  NOT NULL,
    UpdatedAtUtc      DATETIME2(0)   NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_Teams_TeamCode UNIQUE (TeamCode),
    CONSTRAINT CK_Teams_Status CHECK (Status IN ('Active', 'Archived')),
    CONSTRAINT FK_Teams_OwnerEmployee FOREIGN KEY (OwnerEmployeeId) REFERENCES dbo.Employees (EmployeeId)
  );

  CREATE INDEX IX_Teams_TeamName ON dbo.Teams (TeamName);
  CREATE INDEX IX_Teams_Status ON dbo.Teams (Status);
END
GO

IF OBJECT_ID('dbo.TeamMemberships', 'U') IS NULL
BEGIN
  CREATE TABLE dbo.TeamMemberships (
    TeamMembershipId   BIGINT         IDENTITY(1,1) NOT NULL PRIMARY KEY,
    TeamId             BIGINT         NOT NULL,
    EmployeeId         BIGINT         NOT NULL,
    TeamRole           NVARCHAR(50)   NOT NULL,
    EffectiveStartDate DATE           NOT NULL,
    EffectiveEndDate   DATE           NULL,
    CreatedBy          NVARCHAR(256)  NOT NULL,
    CreatedAtUtc       DATETIME2(0)   NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedBy          NVARCHAR(256)  NOT NULL,
    UpdatedAtUtc       DATETIME2(0)   NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_TeamMemberships_Teams FOREIGN KEY (TeamId) REFERENCES dbo.Teams (TeamId),
    CONSTRAINT FK_TeamMemberships_Employees FOREIGN KEY (EmployeeId) REFERENCES dbo.Employees (EmployeeId),
    CONSTRAINT CK_TeamMemberships_DateRange CHECK (EffectiveEndDate IS NULL OR EffectiveEndDate >= EffectiveStartDate)
  );

  CREATE INDEX IX_TeamMemberships_Team ON dbo.TeamMemberships (TeamId, EffectiveStartDate, EffectiveEndDate);
  CREATE INDEX IX_TeamMemberships_Employee ON dbo.TeamMemberships (EmployeeId, EffectiveStartDate, EffectiveEndDate);
  CREATE INDEX IX_TeamMemberships_TeamRole ON dbo.TeamMemberships (TeamRole);
END
GO
