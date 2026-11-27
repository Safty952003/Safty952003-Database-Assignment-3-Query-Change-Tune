-- 12.1

CREATE TABLE [academic].[PassMarkHistory] (
        [HistoryId] INT IDENTITY(1,1) PRIMARY KEY,
        [CourseId] INT NOT NULL,
        [OldPassingScore] DECIMAL(5,2) NULL,
        [NewPassingScore] DECIMAL(5,2) NULL,
        [ChangedAtUtc] DATETIME2(0) NOT NULL,
        [ChangedBy] NVARCHAR(128) NOT NULL
    );

    DECLARE @NewPassingScore DECIMAL(5,2) = 70;
DECLARE @ChangedBy NVARCHAR(128) = SUSER_SNAME();
DECLARE @ChangedAtUtc DATETIME2(0) = SYSUTCDATETIME();

UPDATE [academic].[Courses]
SET [PassingScore] = @NewPassingScore
OUTPUT
    inserted.[Id] AS [CourseId],
    deleted.[PassingScore] AS [OldPassingScore],
    inserted.[PassingScore] AS [NewPassingScore],
    @ChangedAtUtc AS [ChangedAtUtc],
    @ChangedBy AS [ChangedBy]
INTO [academic].[PassMarkHistory] (
    [CourseId],
    [OldPassingScore],
    [NewPassingScore],
    [ChangedAtUtc],
    [ChangedBy]
)
WHERE [DepartmentId] IN (
    SELECT [Id]
    FROM [academic].[Departments]
    WHERE [Code] = N'DSAI'
)
  AND ([PassingScore] IS NULL OR [PassingScore] <> @NewPassingScore);

  SELECT TOP (20) *
FROM [academic].[PassMarkHistory]
ORDER BY [HistoryId] DESC;

-- 12.2

CREATE TABLE [communication].[AnnouncementsArchive] (
        [Id] INT NOT NULL PRIMARY KEY,
        [SectionId] INT NULL,
        [Title] NVARCHAR(255) NOT NULL,
        [Body] NVARCHAR(MAX) NULL,
        [PublishedAtUtc] DATETIME2(7) NULL,
        [ExpiresAtUtc] DATETIME2(7) NULL,
        [CreatedByUserId] INT NULL,
        [CreatedAtUtc] DATETIME2(7) NULL,
        [UpdatedAtUtc] DATETIME2(7) NULL,
        [Status] NVARCHAR(50) NULL,
        [ArchivedAtUtc] DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
    );
    DECLARE @CutoffUtc DATETIME2(7) = DATEADD(MONTH, -6, SYSUTCDATETIME());
    DELETE FROM [communication].[Announcements]
OUTPUT
    deleted.[Id],
    deleted.[SectionId],
    deleted.[Title],
    deleted.[Body],
    deleted.[PublishedAtUtc],
    deleted.[ExpiresAtUtc],
    deleted.[CreatedByUserId],
    deleted.[CreatedAtUtc],
    deleted.[UpdatedAtUtc],
    deleted.[Status],
    SYSUTCDATETIME()
INTO [communication].[AnnouncementsArchive] (
    [Id],
    [SectionId],
    [Title],
    [Body],
    [PublishedAtUtc],
    [ExpiresAtUtc],
    [CreatedByUserId],
    [CreatedAtUtc],
    [UpdatedAtUtc],
    [Status],
    [ArchivedAtUtc]
)
WHERE [ExpiresAtUtc] IS NOT NULL
  AND [ExpiresAtUtc] < @CutoffUtc;

  SELECT TOP (20) *
FROM [communication].[AnnouncementsArchive]
ORDER BY [ArchivedAtUtc] DESC;