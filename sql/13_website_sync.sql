-- task 13

CREATE TABLE [academic].[WebsiteCourses] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [CourseId] INT NOT NULL UNIQUE,
        [Code] NVARCHAR(50) NOT NULL,
        [Title] NVARCHAR(200) NOT NULL,
        [CreditHours] INT NOT NULL,
        [IsVisible] BIT NOT NULL,
        [SyncedAtUtc] DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
    );


    DECLARE @SyncTimeUtc DATETIME2(0) = SYSUTCDATETIME();

MERGE [academic].[WebsiteCourses] AS tgt
USING (
    SELECT
        [Id] AS [CourseId],
        [Code],
        [Title],
        [CreditHours]
    FROM [academic].[Courses]
    WHERE [IsActive] = 1
) AS src
    ON tgt.[CourseId] = src.[CourseId]

WHEN MATCHED AND (
       tgt.[Code] <> src.[Code]
    OR tgt.[Title] <> src.[Title]
    OR tgt.[CreditHours] <> src.[CreditHours]
    OR tgt.[IsVisible] = 0
) THEN
    UPDATE SET
        tgt.[Code] = src.[Code],
        tgt.[Title] = src.[Title],
        tgt.[CreditHours] = src.[CreditHours],
        tgt.[IsVisible] = 1,
        tgt.[SyncedAtUtc] = @SyncTimeUtc

WHEN NOT MATCHED BY TARGET THEN
    INSERT ([CourseId], [Code], [Title], [CreditHours], [IsVisible], [SyncedAtUtc])
    VALUES (src.[CourseId], src.[Code], src.[Title], src.[CreditHours], 1, @SyncTimeUtc)

WHEN NOT MATCHED BY SOURCE AND tgt.[IsVisible] = 1 THEN
    UPDATE SET
        tgt.[IsVisible] = 0,
        tgt.[SyncedAtUtc] = @SyncTimeUtc

OUTPUT
    $ACTION AS [Action],
    COALESCE(inserted.[CourseId], deleted.[CourseId]) AS [CourseId],
    deleted.[Code] AS [OldCode],
    inserted.[Code] AS [NewCode],
    deleted.[Title] AS [OldTitle],
    inserted.[Title] AS [NewTitle],
    deleted.[CreditHours] AS [OldCredits],
    inserted.[CreditHours] AS [NewCredits],
    deleted.[IsVisible] AS [OldVisible],
    inserted.[IsVisible] AS [NewVisible];


    UPDATE TOP (1) [academic].[Courses]
SET [Title] = [Title] + N' - Updated'
WHERE [IsActive] = 1;

UPDATE TOP (1) [academic].[Courses]
SET [IsActive] = 0
WHERE [IsActive] = 1
  AND [Title] NOT LIKE N'%- Updated';


  SELECT
    [Id],
    [CourseId],
    [Code],
    [Title],
    [CreditHours],
    [IsVisible],
    [SyncedAtUtc]
FROM [academic].[WebsiteCourses]
ORDER BY [CourseId];