
-- task 9
SET STATISTICS IO, TIME ON;
SELECT DISTINCT CategoryCode
FROM dbo.LargeSpillDemo;

ALTER TABLE dbo.LargeSpillDemo
ADD CONSTRAINT UQ_LargeSpillDemo_Id UNIQUE (Id);

SELECT DISTINCT Id
FROM dbo.LargeSpillDemo;