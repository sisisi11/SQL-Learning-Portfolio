USE SqlPracticeDB;
GO

SELECT COUNT(*) FROM dbo.Customers;
SELECT COUNT(*) FROM dbo.Products;
SELECT COUNT(*) FROM dbo.Orders;
SELECT COUNT(Email) FROM dbo.Customers;

SELECT SUM(Quantity) FROM dbo.Orders;
SELECT AVG(Quantity) FROM dbo.Orders;
SELECT MIN(Quantity) FROM dbo.Orders;
SELECT MAX(Quantity) FROM dbo.Orders;

SELECT MIN(UnitPrice) FROM dbo.Products;
SELECT MAX(UnitPrice) FROM dbo.Products;
SELECT AVG(UnitPrice) FROM dbo.Products;
SELECT SUM(UnitPrice) FROM dbo.Products;

SELECT Segment, COUNT(*) FROM dbo.Customers GROUP BY Segment;
SELECT Country, COUNT(*) FROM dbo.Customers GROUP BY Country;
SELECT City, COUNT(*) FROM dbo.Customers GROUP BY City;
SELECT Category, COUNT(*) FROM dbo.Products GROUP BY Category;
SELECT IsActive, COUNT(*) FROM dbo.Products GROUP BY IsActive;
SELECT Status, COUNT(*) FROM dbo.Orders GROUP BY Status;

SELECT Status, SUM(Quantity) AS Qty
FROM dbo.Orders
GROUP BY Status;

SELECT ProductID, SUM(Quantity) AS Qty
FROM dbo.Orders
GROUP BY ProductID;

SELECT CustomerID, SUM(Quantity) AS Qty
FROM dbo.Orders
GROUP BY CustomerID;

SELECT CustomerID, AVG(CAST(Quantity AS DECIMAL(10,2))) AS AvgQty
FROM dbo.Orders
GROUP BY CustomerID;

SELECT Category, MIN(UnitPrice) AS Cheapest
FROM dbo.Products
GROUP BY Category;

SELECT Category, MAX(UnitPrice) AS MostExpensive
FROM dbo.Products
GROUP BY Category;

SELECT Category, AVG(UnitPrice) AS AvgPrice
FROM dbo.Products
GROUP BY Category;

SELECT Country, COUNT(*) AS Cnt
FROM dbo.Customers
GROUP BY Country
HAVING COUNT(*) >= 2;

SELECT CustomerID, COUNT(*) AS Orders
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(*) >= 2;

SELECT ProductID, SUM(Quantity) AS Qty
FROM dbo.Orders
GROUP BY ProductID
HAVING SUM(Quantity) >= 3;

SELECT CustomerID,
       SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS Completed
FROM dbo.Orders
GROUP BY CustomerID;

SELECT CustomerID,
       SUM(CASE WHEN Status <> 'Completed' THEN 1 ELSE 0 END) AS NotCompleted
FROM dbo.Orders
GROUP BY CustomerID;

SELECT CustomerID,
       SUM(CASE WHEN DiscountPct IS NOT NULL THEN 1 ELSE 0 END) AS DiscountedOrders
FROM dbo.Orders
GROUP BY CustomerID;

SELECT
    SUM(CASE WHEN Quantity = 1 THEN 1 ELSE 0 END) AS SingleUnitOrders,
    SUM(CASE WHEN Quantity > 1 THEN 1 ELSE 0 END) AS MultiUnitOrders
FROM dbo.Orders;

SELECT
    SUM(CASE WHEN UnitPrice < 100 THEN 1 ELSE 0 END) AS Cheap,
    SUM(CASE WHEN UnitPrice BETWEEN 100 AND 499 THEN 1 ELSE 0 END) AS Mid,
    SUM(CASE WHEN UnitPrice >= 500 THEN 1 ELSE 0 END) AS Expensive
FROM dbo.Products;
