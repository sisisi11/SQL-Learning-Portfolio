USE SqlPracticeDB;
GO

SELECT * FROM dbo.Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM dbo.Products);

SELECT * FROM dbo.Products
WHERE UnitPrice < (SELECT AVG(UnitPrice) FROM dbo.Products);

SELECT * FROM dbo.Products
WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM dbo.Products);

SELECT * FROM dbo.Products
WHERE UnitPrice = (SELECT MIN(UnitPrice) FROM dbo.Products);

SELECT * FROM dbo.Customers
WHERE CustomerID IN (SELECT CustomerID FROM dbo.Orders);

SELECT * FROM dbo.Customers c
WHERE EXISTS
(
    SELECT 1
    FROM dbo.Orders o
    WHERE o.CustomerID = c.CustomerID
);

SELECT * FROM dbo.Customers c
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Orders o
    WHERE o.CustomerID = c.CustomerID
);

SELECT * FROM dbo.Orders o
WHERE EXISTS
(
    SELECT 1
    FROM dbo.Payments p
    WHERE p.OrderID = o.OrderID
);

SELECT * FROM dbo.Orders o
WHERE EXISTS
(
    SELECT 1
    FROM dbo.Returns r
    WHERE r.OrderID = o.OrderID
);

WITH ActiveProducts AS
(
    SELECT * FROM dbo.Products WHERE IsActive = 1
)
SELECT * FROM ActiveProducts;

WITH BulgarianCustomers AS
(
    SELECT * FROM dbo.Customers WHERE Country = 'Bulgaria'
)
SELECT * FROM BulgarianCustomers;

WITH CompletedOrders AS
(
    SELECT * FROM dbo.Orders WHERE Status = 'Completed'
)
SELECT * FROM CompletedOrders;

WITH CustomerOrders AS
(
    SELECT CustomerID, COUNT(*) AS OrderCount
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT * FROM CustomerOrders
ORDER BY OrderCount DESC;

WITH PaymentTotals AS
(
    SELECT OrderID, SUM(Amount) AS Paid
    FROM dbo.Payments
    GROUP BY OrderID
)
SELECT * FROM PaymentTotals
ORDER BY Paid DESC;

SELECT OrderID,
       ROW_NUMBER() OVER (ORDER BY OrderDate, OrderID) AS rn
FROM dbo.Orders;

SELECT ProductName, UnitPrice,
       RANK() OVER (ORDER BY UnitPrice DESC) AS rnk
FROM dbo.Products;

SELECT ProductName, UnitPrice,
       DENSE_RANK() OVER (ORDER BY UnitPrice DESC) AS dense_rnk
FROM dbo.Products;

SELECT ProductName, Category, UnitPrice,
       ROW_NUMBER() OVER
       (
           PARTITION BY Category
           ORDER BY UnitPrice DESC
       ) AS rn
FROM dbo.Products;

SELECT OrderID, CustomerID, OrderDate,
       LAG(OrderDate) OVER
       (
           PARTITION BY CustomerID
           ORDER BY OrderDate, OrderID
       ) AS PrevDate
FROM dbo.Orders;

SELECT OrderID, CustomerID, OrderDate,
       LEAD(OrderDate) OVER
       (
           PARTITION BY CustomerID
           ORDER BY OrderDate, OrderID
       ) AS NextDate
FROM dbo.Orders;

SELECT PaymentID, Amount,
       SUM(Amount) OVER (ORDER BY PaymentID) AS RunningAmount
FROM dbo.Payments;

SELECT PaymentID, Amount,
       AVG(Amount) OVER () AS OverallAvgPayment
FROM dbo.Payments;

SELECT OrderID, CustomerID, Quantity,
       SUM(Quantity) OVER (PARTITION BY CustomerID) AS CustomerQty
FROM dbo.Orders;

SELECT OrderID, CustomerID, Quantity,
       AVG(CAST(Quantity AS DECIMAL(10,2)))
       OVER (PARTITION BY CustomerID) AS CustomerAvgQty
FROM dbo.Orders;

SELECT PaymentID, PaymentMethod, Amount,
       SUM(Amount) OVER (PARTITION BY PaymentMethod) AS MethodTotal
FROM dbo.Payments;

SELECT PaymentID, PaymentMethod, Amount,
       ROW_NUMBER() OVER
       (
           PARTITION BY PaymentMethod
           ORDER BY Amount DESC
       ) AS rn
FROM dbo.Payments;
