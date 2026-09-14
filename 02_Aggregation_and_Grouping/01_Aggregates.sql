USE SqlPracticeDB;
GO

SELECT COUNT(*) AS CustomerCount
FROM dbo.Customers;

SELECT COUNT(*) AS ProductCount
FROM dbo.Products;

SELECT COUNT(*) AS OrderCount
FROM dbo.Orders;

SELECT
    MIN(UnitPrice) AS MinPrice,
    MAX(UnitPrice) AS MaxPrice,
    AVG(UnitPrice) AS AvgPrice
FROM dbo.Products;

SELECT SUM(Quantity) AS TotalUnits
FROM dbo.Orders;

SELECT COUNT(Email) AS CustomersWithEmail
FROM dbo.Customers;

SELECT AVG(CAST(Quantity AS DECIMAL(10,2))) AS AverageOrderQuantity
FROM dbo.Orders;
