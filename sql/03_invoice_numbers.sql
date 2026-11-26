-- 3.1

    CREATE SEQUENCE finance.Seq_InvoiceNumber_2026
        AS BIGINT
        START WITH 1
        INCREMENT BY 1
        MINVALUE 1
        NO CYCLE;
-- 3.2
DECLARE @NextSeq BIGINT = NEXT VALUE FOR finance.Seq_InvoiceNumber_2026;
DECLARE @NewInvoiceNumber NVARCHAR(50) =
    N'LAB-INV-2026-' + RIGHT(REPLICATE(N'0', 6) + CAST(@NextSeq AS NVARCHAR(20)), 6);

DECLARE @StudentId INT = (
    SELECT TOP (1) Id
    FROM [identity].StudentProfiles
    ORDER BY Id
);

DECLARE @TermId INT = (
    SELECT TOP (1) Id
    FROM delivery.AcademicTerms
    ORDER BY Id DESC
);

INSERT INTO finance.Invoices
    (InvoiceNumber, StudentId, TermId, CurrencyCode, IssuedAtUtc, DueAtUtc, TotalAmount, PaidAmount, CreatedAtUtc, Status)
VALUES
    (
        @NewInvoiceNumber,
        @StudentId,
        @TermId,
        N'EGP',
        SYSUTCDATETIME(),
        DATEADD(DAY, 30, SYSUTCDATETIME()),
        4500.00,
        0.00,
        SYSUTCDATETIME(),
        1
    );

SELECT *
FROM finance.Invoices
WHERE InvoiceNumber = @NewInvoiceNumber;

-- 3.3
BEGIN TRANSACTION;

DECLARE @CancelledNumber NVARCHAR(50) =
    N'LAB-INV-2026-' + RIGHT(
        REPLICATE(N'0', 6) + CAST(NEXT VALUE FOR finance.Seq_InvoiceNumber_2026 AS NVARCHAR(20)),
        6
    );

SELECT @CancelledNumber AS NumberTakenBeforeRollback;

ROLLBACK TRANSACTION;

SELECT
    N'LAB-INV-2026-' + RIGHT(
        REPLICATE(N'0', 6) + CAST(NEXT VALUE FOR finance.Seq_InvoiceNumber_2026 AS NVARCHAR(20)),
        6
    ) AS NextNumberAfterRollback;