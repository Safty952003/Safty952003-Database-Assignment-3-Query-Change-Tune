-- 2.1
INSERT INTO academic.Departments
    (Code, Name, Description, IsActive, CreatedAtUtc, IsDeleted)
VALUES
    (N'DSAI', N'Data Science & Artificial Intelligence', N'Data Science & Artificial Intelligence Department', 1, SYSUTCDATETIME(), 0);

    -- 2.2
DECLARE @DeptId INT = (
    SELECT TOP (1) Id
    FROM academic.Departments
    WHERE Code = N'DSAI'
);

INSERT INTO academic.Courses
    (DepartmentId, Code, Title, Description, CreditHours, PassingScore, IsActive, CreatedAtUtc, Price)
VALUES
    (@DeptId, N'DSAI-101', N'Introduction to Data Analysis', N'Introduction to Data Analysis course', 3, 60, 1, SYSUTCDATETIME(), 0);

    -- 2.3
INSERT INTO delivery.AcademicTerms
    (AcademicYear, TermCode, Name, StartDate, EndDate, RegistrationStartDate, RegistrationEndDate, Status)
VALUES
    (2027, N'SUM-2027', N'Summer 2027', '2027-06-15', '2027-08-31', '2027-05-01', '2027-06-10', 1);

    -- 2.4
INSERT INTO communication.Announcements
    (SectionId, Title, Body, PublishedAtUtc, ExpiresAtUtc, CreatedByUserId, CreatedAtUtc, UpdatedAtUtc, Status)
VALUES
    (NULL, N'Summer 2027 Registration', N'Summer 2027 registration opens on 1 May.', SYSUTCDATETIME(), '2027-06-11T23:59:59', 1, SYSUTCDATETIME(), SYSUTCDATETIME(), 1);

    -- 2.5
INSERT INTO [identity].Roles
    (Code, Name, Description, IsSystem, IsDeleted)
VALUES
    (N'TA', N'Teaching Assistant', N'Teaching Assistant role', 0, 0);