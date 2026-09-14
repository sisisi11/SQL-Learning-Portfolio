USE SqlPracticeDB;
GO

SELECT
    Segment,
    COUNT(*) AS CustomerCount
FROM dbo.Customers
GROUP BY Segment;

SELECT
    Country,
    COUNT(*) AS CustomerCount
FROM dbo.Customers
GROUP BY Country
ORDER BY CustomerCount DESC;

SELECT
    Category,
    COUNT(*) AS ProductCount,
    AVG(UnitPrice) AS AveragePrice
FROM dbo.Products
GROUP BY Category;

SELECT
    Status,
    COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY Status;

SELECT
    CustomerID,
    SUM(Quantity) AS TotalQuantity
FROM dbo.Orders
GROUP BY CustomerID
ORDER BY TotalQuantity DESC;

SELECT
    CustomerID,
    COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(*) > 1;

SELECT
    Category,
    AVG(UnitPrice) AS AveragePrice
FROM dbo.Products
GROUP BY Category
HAVING AVG(UnitPrice) > 150;
