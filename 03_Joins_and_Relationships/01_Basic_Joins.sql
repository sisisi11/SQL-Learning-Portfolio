USE SqlPracticeDB;
GO

SELECT
    o.OrderID,
    c.FullName,
    o.OrderDate,
    o.Status
FROM dbo.Orders o
INNER JOIN dbo.Customers c
    ON c.CustomerID = o.CustomerID;

SELECT
    o.OrderID,
    p.ProductName,
    o.Quantity
FROM dbo.Orders o
INNER JOIN dbo.Products p
    ON p.ProductID = o.ProductID;

SELECT
    o.OrderID,
    c.FullName,
    p.ProductName,
    o.Quantity,
    p.UnitPrice,
    p.UnitPrice * o.Quantity AS GrossValue
FROM dbo.Orders o
JOIN dbo.Customers c
    ON c.CustomerID = o.CustomerID
JOIN dbo.Products p
    ON p.ProductID = o.ProductID;

SELECT
    c.CustomerID,
    c.FullName,
    o.OrderID
FROM dbo.Customers c
LEFT JOIN dbo.Orders o
    ON o.CustomerID = c.CustomerID
ORDER BY c.CustomerID;

SELECT
    c.CustomerID,
    c.FullName
FROM dbo.Customers c
LEFT JOIN dbo.Orders o
    ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL;
