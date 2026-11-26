-- 1.1
SELECT
    Id,
    InvoiceNumber,
    StudentId,
    CurrencyCode,
    Status,
    TotalAmount AS InvoiceAmount,
    PaidAmount,
    (TotalAmount - PaidAmount) AS RemainingAmount,
    DATEDIFF(DAY, CAST(DueAtUtc AS DATE), CAST(SYSUTCDATETIME() AS DATE)) AS DaysLate,
    DueAtUtc
INTO #LateInvoices
FROM finance.Invoices
WHERE PaidAmount < TotalAmount
  AND DueAtUtc < SYSUTCDATETIME();

SELECT
    Id,
    InvoiceNumber,
    StudentId,
    CurrencyCode,
    Status,
    InvoiceAmount,
    PaidAmount,
    RemainingAmount,
    DaysLate
FROM #LateInvoices;

-- 1.2
ALTER TABLE #LateInvoices
ADD Priority NVARCHAR(10);

UPDATE #LateInvoices
SET Priority = CASE
    WHEN DaysLate > 60 OR RemainingAmount > 10000 THEN N'Urgent'
    WHEN DaysLate > 30 THEN N'Medium'
    ELSE N'Low'
END;

SELECT
    Id,
    InvoiceNumber,
    StudentId,
    CurrencyCode,
    InvoiceAmount,
    PaidAmount,
    RemainingAmount,
    DaysLate,
    Priority
FROM #LateInvoices;

-- 1.3
SELECT
    Id,
    InvoiceNumber,
    StudentId,
    CurrencyCode,
    InvoiceAmount,
    PaidAmount,
    RemainingAmount,
    DaysLate,
    Priority
FROM #LateInvoices
ORDER BY
    CASE Priority
        WHEN N'Urgent' THEN 1
        WHEN N'Medium' THEN 2
        WHEN N'Low'    THEN 3
        ELSE 4
    END,
    RemainingAmount DESC;