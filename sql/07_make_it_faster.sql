CREATE INDEX IX_Users_Email
    ON [identity].Users (Email)
    INCLUDE (FirstName, LastName);

CREATE INDEX IX_Users_LastName
    ON [identity].Users (LastName)
    INCLUDE (FirstName, Email);

CREATE INDEX IX_Users_CreatedAtUtc
    ON [identity].Users (CreatedAtUtc)
    INCLUDE (Email);

CREATE INDEX IX_Payments_PaidAtUtc
    ON finance.Payments (PaidAtUtc)
    INCLUDE (InvoiceId, Amount);

CREATE INDEX IX_Invoices_Number
    ON finance.Invoices (InvoiceNumber);

    -- 7.1 before
 SET STATISTICS IO, TIME ON;
SELECT Id, Email
FROM [identity].Users
WHERE YEAR(CreatedAtUtc) = 2026
AND MONTH(CreatedAtUtc) = 3;

-- 7.1 after 
    SET STATISTICS IO, TIME ON;

SELECT Id, Email
FROM [identity].Users
WHERE CreatedAtUtc >= '2026-03-01T00:00:00'
  AND CreatedAtUtc <  '2026-04-01T00:00:00';

  -- 7.2 before 
      SET STATISTICS IO, TIME ON;
SELECT Id, InvoiceId, Amount
FROM finance.Payments
WHERE DATEDIFF(DAY, PaidAtUtc,
 SYSUTCDATETIME()) <= 30;

 -- 7.2 after
       SET STATISTICS IO, TIME ON;

 SELECT Id, InvoiceId, Amount
FROM finance.Payments
WHERE PaidAtUtc >= DATEADD(DAY, -30, SYSUTCDATETIME());

--7.3 before
      SET STATISTICS IO, TIME ON;
SELECT Id, FirstName, LastName
FROM [identity].Users
WHERE LEFT(LastName, 3) = N'Abd';
-- 7.3 after 
      SET STATISTICS IO, TIME ON;
SELECT Id, FirstName, LastName
FROM [identity].Users
WHERE LastName LIKE N'Abd%';
-- 7.4 before 
      SET STATISTICS IO, TIME ON;
SELECT *
FROM operations.AuditLogs
WHERE Id + 1 = 50001;

-- 7.4 after 
SET STATISTICS IO, TIME ON;
SELECT *
FROM operations.AuditLogs
WHERE Id = 50000;

-- 7.5 before 
SET STATISTICS IO, TIME ON;
SELECT Id, TotalAmount, PaidAmount
FROM finance.Invoices
WHERE InvoiceNumber
 = N'LAB-INV-2026-000001';
 -- 7.5 after 
 SET STATISTICS IO, TIME ON;
 SELECT Id, TotalAmount, PaidAmount
FROM finance.Invoices
WHERE InvoiceNumber = 'LAB-INV-2026-000001';

-- 7.6 before
 SET STATISTICS IO, TIME ON;
 DECLARE @Email NVARCHAR(320) = N'...';
SELECT Id, FirstName, LastName
FROM [identity].Users
WHERE UPPER(Email) = UPPER(@Email);

-- 7.6 after
 SET STATISTICS IO, TIME ON;
DECLARE @Email1 NVARCHAR(320) = N'...';
SELECT Id, FirstName, LastName
FROM [identity].Users
WHERE Email = @Email1;

-- 7.7 before 
 SET STATISTICS IO, TIME ON;
DECLARE @LastName NVARCHAR(100) = N'Hassan';
SELECT Id, FirstName, Email
FROM [identity].Users
WHERE (@LastName IS NULL
OR LastName = @LastName);

-- 7.7 after
 SET STATISTICS IO, TIME ON;
DECLARE @LastName1 NVARCHAR(100) = N'Hassan';

SELECT Id, FirstName, Email
FROM [identity].Users
WHERE LastName = @LastName1
   OR @LastName1 IS NULL
OPTION (RECOMPILE);

-- 7.8 before
 SET STATISTICS IO, TIME ON;
 SELECT Id, InvoiceId, Amount
FROM finance.Payments
WHERE COALESCE(PaidAtUtc, '1900-01-01') >= '2026-10-01T00:00:00';

-- 7.8 after 
 SET STATISTICS IO, TIME ON;
SELECT Id, InvoiceId, Amount
FROM finance.Payments
WHERE PaidAtUtc >= '2026-10-01T00:00:00';
