USE SqlPracticeDB;
GO

SELECT TOP 1 * FROM dbo.Customers;
SELECT TOP 1 * FROM dbo.Products;
SELECT TOP 3 * FROM dbo.Orders;

SELECT CustomerID, FullName FROM dbo.Customers;
SELECT ProductID, ProductName FROM dbo.Products;
SELECT OrderID, OrderDate FROM dbo.Orders;

SELECT DISTINCT Country FROM dbo.Customers;
SELECT DISTINCT City FROM dbo.Customers;
SELECT DISTINCT Segment FROM dbo.Customers;
SELECT DISTINCT Category FROM dbo.Products;
SELECT DISTINCT Status FROM dbo.Orders;

SELECT * FROM dbo.Customers WHERE CustomerID = 1;
SELECT * FROM dbo.Customers WHERE CustomerID > 5;
SELECT * FROM dbo.Products WHERE ProductID <> 1;
SELECT * FROM dbo.Products WHERE UnitPrice > 100;
SELECT * FROM dbo.Products WHERE UnitPrice >= 399;
SELECT * FROM dbo.Products WHERE UnitPrice < 200;
SELECT * FROM dbo.Products WHERE UnitPrice <= 399;
SELECT * FROM dbo.Customers WHERE Country <> 'Bulgaria';

SELECT * FROM dbo.Customers WHERE Country = 'Bulgaria' AND City = 'Sofia';
SELECT * FROM dbo.Customers WHERE Country = 'Bulgaria' OR Country = 'Italy';
SELECT * FROM dbo.Customers WHERE NOT Country = 'Bulgaria';

SELECT * FROM dbo.Customers WHERE CustomerID IN (1,3,5);
SELECT * FROM dbo.Products WHERE ProductID IN (2,4,6,8);
SELECT * FROM dbo.Products WHERE Category NOT IN ('Furniture');

SELECT * FROM dbo.Products WHERE UnitPrice BETWEEN 50 AND 150;
SELECT * FROM dbo.Products WHERE UnitPrice NOT BETWEEN 100 AND 500;
SELECT * FROM dbo.Customers WHERE CreatedAt BETWEEN '2025-03-01' AND '2025-05-31';

SELECT * FROM dbo.Customers WHERE FullName LIKE 'A%';
SELECT * FROM dbo.Customers WHERE FullName LIKE '%a';
SELECT * FROM dbo.Customers WHERE FullName LIKE '%Pet%';
SELECT * FROM dbo.Products WHERE ProductName LIKE '%e%';

SELECT FullName, City FROM dbo.Customers ORDER BY FullName;
SELECT FullName, CreatedAt FROM dbo.Customers ORDER BY CreatedAt DESC;
SELECT ProductName, UnitPrice FROM dbo.Products ORDER BY UnitPrice;
SELECT ProductName, UnitPrice FROM dbo.Products ORDER BY UnitPrice DESC;

SELECT ProductName, UnitPrice, UnitPrice + 10 AS PlusTen FROM dbo.Products;
SELECT ProductName, UnitPrice, UnitPrice - 10 AS MinusTen FROM dbo.Products;
SELECT ProductName, UnitPrice, UnitPrice * 2 AS DoublePrice FROM dbo.Products;
SELECT OrderID, Quantity, Quantity + 1 AS QuantityPlusOne FROM dbo.Orders;

SELECT FullName, LOWER(FullName) AS LowerName FROM dbo.Customers;
SELECT FullName, UPPER(FullName) AS UpperName FROM dbo.Customers;
SELECT City, LEN(City) AS CityLength FROM dbo.Customers;
SELECT ProductName, LEFT(ProductName,3) AS FirstThree FROM dbo.Products;
SELECT ProductName, RIGHT(ProductName,3) AS LastThree FROM dbo.Products;

SELECT OrderID, OrderDate, YEAR(OrderDate) AS Yr FROM dbo.Orders;
SELECT OrderID, OrderDate, MONTH(OrderDate) AS Mn FROM dbo.Orders;
SELECT OrderID, OrderDate, DAY(OrderDate) AS Dy FROM dbo.Orders;

SELECT FullName, COALESCE(Email,'missing') AS EmailValue FROM dbo.Customers;
SELECT OrderID, COALESCE(DiscountPct,0) AS DiscountValue FROM dbo.Orders;

SELECT ProductName,
       CASE WHEN IsActive = 1 THEN 'Active' ELSE 'Inactive' END AS Status
FROM dbo.Products;
