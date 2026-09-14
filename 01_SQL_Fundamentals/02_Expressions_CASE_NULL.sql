USE SqlPracticeDB;
GO

SELECT
    ProductName,
    UnitPrice,
    UnitPrice * 1.20 AS PriceWithVAT
FROM dbo.Products;

SELECT
    FullName,
    UPPER(FullName) AS UpperName
FROM dbo.Customers;

SELECT
    FullName,
    LEN(FullName) AS NameLength
FROM dbo.Customers;

SELECT
    FullName,
    Country + ' / ' + City AS Location
FROM dbo.Customers;

SELECT
    FullName,
    COALESCE(Email,'no-email') AS EmailValue
FROM dbo.Customers;

SELECT
    FullName,
    YEAR(CreatedAt) AS CreatedYear,
    MONTH(CreatedAt) AS CreatedMonth
FROM dbo.Customers;

SELECT
    ProductName,
    UnitPrice,
    CASE
        WHEN UnitPrice >= 1000 THEN 'High'
        WHEN UnitPrice >= 300 THEN 'Medium'
        ELSE 'Low'
    END AS PriceBand
FROM dbo.Products;

SELECT
    FullName,
    Segment,
    CASE
        WHEN Segment = 'Business' THEN 'B2B'
        WHEN Segment = 'Premium' THEN 'High Value'
        ELSE 'Standard'
    END AS SegmentLabel
FROM dbo.Customers;

SELECT *
FROM dbo.Customers
WHERE Email IS NULL;

SELECT *
FROM dbo.Customers
WHERE Email IS NOT NULL;
