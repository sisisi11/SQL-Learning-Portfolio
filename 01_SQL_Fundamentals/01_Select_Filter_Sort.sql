USE SqlPracticeDB;
GO

SELECT *
FROM dbo.Customers;

SELECT
    FullName,
    Country
FROM dbo.Customers;

SELECT
    CustomerID,
    FullName AS CustomerName,
    Segment
FROM dbo.Customers;

SELECT DISTINCT Country
FROM dbo.Customers;

SELECT DISTINCT Segment
FROM dbo.Customers;

SELECT TOP (5)
    ProductName,
    UnitPrice
FROM dbo.Products
ORDER BY UnitPrice DESC;

SELECT *
FROM dbo.Customers
WHERE Country = 'Bulgaria';

SELECT *
FROM dbo.Customers
WHERE Segment = 'Premium';

SELECT *
FROM dbo.Customers
WHERE Country = 'Bulgaria'
  AND Segment = 'Retail';

SELECT *
FROM dbo.Customers
WHERE Segment = 'Premium'
   OR Segment = 'Business';

SELECT *
FROM dbo.Products
WHERE UnitPrice BETWEEN 100 AND 500;

SELECT *
FROM dbo.Products
WHERE Category IN ('Electronics','Furniture');

SELECT *
FROM dbo.Customers
WHERE FullName LIKE 'A%';

SELECT *
FROM dbo.Products
WHERE ProductName LIKE '%o%';

SELECT
    ProductName,
    UnitPrice
FROM dbo.Products
WHERE IsActive = 1
ORDER BY UnitPrice DESC;
