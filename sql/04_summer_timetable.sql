-- 4
DECLARE @Summer2027TermId INT = (
    SELECT TOP (1) Id
    FROM delivery.AcademicTerms
    WHERE TermCode = N'SUM-2027'
       OR Name = N'Summer 2027'
    ORDER BY Id DESC
);

DECLARE @SourceTermId INT = (
    SELECT TOP (1) Id
    FROM delivery.AcademicTerms
    WHERE Id <> @Summer2027TermId
    ORDER BY StartDate DESC, Id DESC
);

INSERT INTO delivery.Sections
    (CourseId, TermId, SectionCode, Capacity, Location, CreatedAtUtc, DeliveryMode, Status)
SELECT
    CourseId,
    @Summer2027TermId AS TermId,
    SectionCode,
    Capacity,
    Location,
    SYSUTCDATETIME() AS CreatedAtUtc,
    DeliveryMode,
    Status
FROM delivery.Sections
WHERE TermId = @SourceTermId;

SELECT
    Id,
    CourseId,
    TermId,
    SectionCode,
    Capacity,
    Location,
    CreatedAtUtc,
    DeliveryMode,
    Status
FROM delivery.Sections
WHERE TermId = @Summer2027TermId
ORDER BY Id;