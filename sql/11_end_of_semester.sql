--11.1
UPDATE [academic].[Courses]
SET [PassingScore] = 65
WHERE [Code] LIKE 'DSAI%' 
  AND ([PassingScore] IS NULL OR [PassingScore] <> 65);

SELECT [Id], [DepartmentId], [Code], [Title], [PassingScore]
FROM [academic].[Courses]
WHERE [Code] LIKE 'DSAI%';

--11.2
UPDATE [delivery].[Enrollments]
SET [FinalGrade] = CASE
        WHEN [FinalScore] >= 90 THEN 'A'
        WHEN [FinalScore] >= 80 THEN 'B'
        WHEN [FinalScore] >= 70 THEN 'C'
        WHEN [FinalScore] >= 60 THEN 'D'
        ELSE 'F'
    END
WHERE [FinalScore] IS NOT NULL
  AND [CompletedAtUtc] IS NOT NULL; 

-- 11.3
UPDATE [identity].[Roles]
SET [IsDeleted] = 1
WHERE [Name] = 'Teaching Assistant';

SELECT [Id], [Code], [Name], [IsSystem], [IsDeleted]
FROM [identity].[Roles]
WHERE [Name] = 'Teaching Assistant' OR [Code] = 'TA';

-- 11.4
CREATE TABLE [finance].[StagingPayments] (
    [StagingId] INT IDENTITY(1,1) PRIMARY KEY,
    [InvoiceId] INT NOT NULL,
    [PaymentMethodId] INT NOT NULL,
    [Amount] DECIMAL(18,2) NOT NULL,
    [CurrencyCode] VARCHAR(10) NOT NULL DEFAULT 'EGP',
    [ExternalReference] VARCHAR(100) NULL,
    [PaidAtUtc] DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    [Kind] VARCHAR(30) NULL,
    [Status] VARCHAR(30) NULL
);

INSERT INTO [finance].[StagingPayments]
    ([InvoiceId], [PaymentMethodId], [Amount], [CurrencyCode], [ExternalReference], [PaidAtUtc], [Kind], [Status])
SELECT TOP (3)
    [InvoiceId], [PaymentMethodId], [Amount], [CurrencyCode], [ExternalReference], [PaidAtUtc], [Kind], [Status]
FROM [finance].[Payments];

SELECT COUNT(*) AS [RowsBeforeTruncate]
FROM [finance].[StagingPayments];

TRUNCATE TABLE [finance].[StagingPayments];

SELECT COUNT(*) AS [RowsAfterTruncate]
FROM [finance].[StagingPayments];

-- 11.5

USE [LmsTrainingLab];
GO

DROP TABLE IF EXISTS [dbo].[LargeSpillDemo];
DROP TABLE IF EXISTS [finance].[StagingPayments];

SELECT [TABLE_SCHEMA], [TABLE_NAME]
FROM [INFORMATION_SCHEMA].[TABLES]
WHERE [TABLE_TYPE] = 'BASE TABLE'
ORDER BY [TABLE_SCHEMA], [TABLE_NAME];