-- 5.1
SELECT
    Code AS [Course Code],
    Title AS [Course Title],
    CreditHours AS [Credit Hours]
FROM academic.Courses
ORDER BY
    CreditHours DESC,
    Title ASC;
    -- 5.2
SELECT TOP (5)
    Id,
    UserId,
    StudentNumber,
    EmergencyContactName,
    EmergencyContactPhone
FROM [identity].[StudentProfiles]
ORDER BY NEWID();

-- 5.3
SELECT
    Id,
    UserId,
    Email,
    FirstName,
    LastName
FROM [identity].[Users]
WHERE DATALENGTH(Email) <> DATALENGTH(TRIM(Email));

-- 5.4
SELECT
    Id,
    UserId,
    Email,
    FirstName,
    LastName
FROM [identity].[Users]
WHERE Email COLLATE Latin1_General_CS_AS <> LOWER(Email) COLLATE Latin1_General_CS_AS;

-- 5.5
SELECT
    Id,
    UserId,
    Email,
    FirstName,
    LastName
FROM [identity].[Users]
WHERE Email IS NULL
   OR CHARINDEX('@', Email) <= 1
   OR CHARINDEX('.', SUBSTRING(Email, CHARINDEX('@', Email) + 1, DATALENGTH(Email))) = 0;
   -- 5.6
SELECT DISTINCT
    SUBSTRING(
        Email,
        CHARINDEX('@', Email) + 1,
        DATALENGTH(Email)
    ) AS [Email Provider]
FROM [identity].[Users]
WHERE Email IS NOT NULL
  AND CHARINDEX('@', Email) > 0
ORDER BY [Email Provider] ASC;

-- 5.7
SELECT
    Id,
    UserId,
    Email,
    FirstName,
    LastName,
    LastLoginAtUtc,
    Status,
    IsDeleted
FROM [identity].[Users]
ORDER BY
    CASE WHEN LastLoginAtUtc IS NULL THEN 1 ELSE 0 END ASC,
    LastLoginAtUtc DESC,
    Id ASC;

    -- 5.8
SELECT
    Id,
    InvoiceId,
    PaymentMethodId,
    Amount,
    CurrencyCode,
    ExternalReference,
    PaidAtUtc,
    CreatedByUserId,
    CreatedAtUtc,
    Kind,
    Status
FROM [finance].[Payments]
WHERE PaidAtUtc >= '2026-10-01T00:00:00'
  AND PaidAtUtc <  '2026-11-01T00:00:00'
ORDER BY PaidAtUtc ASC, Id ASC;

-- 5.9
SELECT
    Id,
    InvoiceId,
    PaymentMethodId,
    Amount,
    CurrencyCode,
    ExternalReference,
    PaidAtUtc,
    CAST(PaidAtUtc AT TIME ZONE 'UTC' AT TIME ZONE 'Egypt Standard Time' AS DATETIME2) AS PaidAtCairo,
    CreatedByUserId,
    Kind,
    Status
FROM [finance].[Payments]
WHERE PaidAtUtc IS NOT NULL
  AND CAST(PaidAtUtc AT TIME ZONE 'UTC' AT TIME ZONE 'Egypt Standard Time' AS TIME) >= '00:00:00'
  AND CAST(PaidAtUtc AT TIME ZONE 'UTC' AT TIME ZONE 'Egypt Standard Time' AS TIME) <  '05:00:00'
ORDER BY PaidAtCairo ASC, Id ASC;

-- 5.10
SELECT
    Id,
    SectionId,
    SessionDate,
    StartsAtUtc,
    EndsAtUtc,
    Topic,
    CreatedByUserId,
    CreatedAtUtc
FROM [attendance].[AttendanceSessions]
WHERE DATENAME(WEEKDAY, SessionDate) = 'Friday'
ORDER BY SessionDate ASC, StartsAtUtc ASC, Id ASC;

-- 5.11
SELECT
    Id,
    UserId,
    FirstName,
    LastName,
    PhoneNumber
FROM [identity].[Users]
WHERE PhoneNumber IS NOT NULL
  AND (
      REPLACE(REPLACE(REPLACE(TRIM(PhoneNumber), ' ', ''), '-', ''), '+', '') LIKE '010%'
      OR REPLACE(REPLACE(REPLACE(TRIM(PhoneNumber), ' ', ''), '-', ''), '+', '') LIKE '011%'
      OR REPLACE(REPLACE(REPLACE(TRIM(PhoneNumber), ' ', ''), '-', ''), '+', '') LIKE '012%'
      OR REPLACE(REPLACE(REPLACE(TRIM(PhoneNumber), ' ', ''), '-', ''), '+', '') LIKE '015%'
      OR REPLACE(REPLACE(REPLACE(TRIM(PhoneNumber), ' ', ''), '-', ''), '+', '') LIKE '2010%'
      OR REPLACE(REPLACE(REPLACE(TRIM(PhoneNumber), ' ', ''), '-', ''), '+', '') LIKE '2011%'
      OR REPLACE(REPLACE(REPLACE(TRIM(PhoneNumber), ' ', ''), '-', ''), '+', '') LIKE '2012%'
      OR REPLACE(REPLACE(REPLACE(TRIM(PhoneNumber), ' ', ''), '-', ''), '+', '') LIKE '2015%'
  )
ORDER BY Id ASC;

-- 5.12
SELECT
    Id,
    UserId,
    FirstName,
    LastName,
    CASE
        WHEN PhoneNumber IS NULL THEN NULL
        WHEN LEN(TRIM(PhoneNumber)) <= 5 THEN TRIM(PhoneNumber)
        ELSE LEFT(TRIM(PhoneNumber), 3)
           + REPLICATE('*', DATALENGTH(TRIM(PhoneNumber)) / CASE WHEN UNICODE(TRIM(PhoneNumber)) > 255 THEN 2 ELSE 1 END - 5)
           + RIGHT(TRIM(PhoneNumber), 2)
    END AS MaskedPhoneNumber
FROM [identity].[Users]
ORDER BY Id ASC;

-- 5.13
SELECT
    Id,
    InvoiceNumber,
    TRY_CAST(
        SUBSTRING(
            RIGHT(TRIM(InvoiceNumber), CHARINDEX('-', REVERSE(TRIM(InvoiceNumber))) - 1),
            PATINDEX('%[0-9]%', RIGHT(TRIM(InvoiceNumber), CHARINDEX('-', REVERSE(TRIM(InvoiceNumber))) - 1)),
            DATALENGTH(TRIM(InvoiceNumber))
        ) AS BIGINT
    ) AS RunningNumber
FROM [finance].[Invoices]
WHERE InvoiceNumber IS NOT NULL
  AND CHARINDEX('-', TRIM(InvoiceNumber)) > 0
ORDER BY RunningNumber ASC, Id ASC;

-- 5.14
SELECT
    Id,
    ModuleId,
    Title,
    EstimatedMinutes,
    CASE
        WHEN EstimatedMinutes IS NULL THEN 'Not set'
        ELSE CONCAT(
            EstimatedMinutes / 60,
            ' h ',
            EstimatedMinutes % 60,
            ' min'
        )
    END AS FormattedLength
FROM [content].[Lessons]
ORDER BY SortOrder ASC, Id ASC;

-- 5.15
SELECT
    Id,
    SectionId,
    Title,
    Body,
    PublishedAtUtc,
    ExpiresAtUtc,
    Status
FROM [communication].[Announcements]
WHERE Title LIKE '%[0-9]!%%' ESCAPE '!'
   OR Body  LIKE '%[0-9]!%%' ESCAPE '!'
   OR Title LIKE '%[0-9] !%%' ESCAPE '!'
   OR Body  LIKE '%[0-9] !%%' ESCAPE '!'
ORDER BY PublishedAtUtc DESC, Id DESC;


-- 5.16
SELECT TOP (5) WITH TIES
    Id,
    InvoiceNumber,
    TotalAmount
FROM [finance].[Invoices]
WHERE TotalAmount IS NOT NULL
ORDER BY TotalAmount DESC;

-- 5.17
SELECT TOP (10) PERCENT
    *
FROM [finance].[Payments]
WHERE Amount IS NOT NULL
ORDER BY Amount DESC;

-- 5.18
SELECT
    *
FROM [delivery].[Sections]
WHERE Location IS NULL
   OR Location <> 'Hall A'
ORDER BY Id ASC;

-- 5.19
SELECT
    Id,
    InvoiceNumber,
    TotalAmount,
    PaidAmount,
    (TotalAmount - PaidAmount) AS AmountOwed,
   CASE
    WHEN PaidAmount > 0 AND PaidAmount < TotalAmount THEN 'Partially Paid'
    WHEN PaidAmount = 0 THEN 'Not Paid'
END AS PaymentStatus,
    CASE
        WHEN DueAtUtc < CAST(GETUTCDATE() AS DATE) THEN 'Overdue'
        ELSE 'Not Overdue'
    END AS OverdueStatus,
    CAST(
        (PaidAmount * 100.0) / NULLIF(TotalAmount, 0)
        AS DECIMAL(5, 1)
    ) AS PercentagePaid
FROM [finance].[Invoices]
WHERE TotalAmount > PaidAmount
ORDER BY (TotalAmount - PaidAmount) DESC, Id ASC;

-- 5.20
SELECT
    *
FROM [identity].[Users]
ORDER BY CreatedAtUtc DESC, Id DESC
OFFSET 40 ROWS
FETCH NEXT 20 ROWS ONLY;

-- 5.21
DECLARE @LastSeenId BIGINT = 0;
SELECT TOP (50)
    *
FROM [operations].[AuditLogs] 
WHERE Id > @LastSeenId
ORDER BY Id ASC;

-- 5.22
SELECT TOP (10)
    Id,
    Amount,
    PaidAtUtc 
FROM [finance].[Payments]
ORDER BY PaidAtUtc DESC;

-- 5.23
SELECT TOP (10)
    UPPER(TRIM(Title)) AS LessonTitle,
    LEN(TRIM(Title)) AS TitleLength,
    CASE
        WHEN EstimatedMinutes IS NULL THEN 'Not Set'
        WHEN EstimatedMinutes <= 15 THEN 'Quick'
        WHEN EstimatedMinutes <= 45 THEN 'Standard'
        ELSE 'Long'
    END AS DurationCategory
FROM [content].[Lessons]
WHERE IsPublished = 1
  AND Title IS NOT NULL
  AND LEN(TRIM(Title)) > 40
GROUP BY
    UPPER(TRIM(Title)),
    LEN(TRIM(Title)),
    CASE
        WHEN EstimatedMinutes IS NULL THEN 'Not Set'
        WHEN EstimatedMinutes <= 15 THEN 'Quick'
        WHEN EstimatedMinutes <= 45 THEN 'Standard'
        ELSE 'Long'
    END
ORDER BY
    TitleLength DESC,
    LessonTitle ASC;

   -- 5.24
SELECT DISTINCT TOP (12)
    CONVERT(CHAR(7), DueAtUtc, 120) AS DueMonth,
    CurrencyCode,
    CASE
        WHEN PaidAmount > 0 AND PaidAmount < TotalAmount THEN 'Partially Paid'
        ELSE 'Not Paid'
    END AS PaymentState
FROM [finance].[Invoices]
WHERE DueAtUtc < CAST(GETUTCDATE() AS DATE)
  AND PaidAmount < TotalAmount
ORDER BY
    DueMonth DESC;