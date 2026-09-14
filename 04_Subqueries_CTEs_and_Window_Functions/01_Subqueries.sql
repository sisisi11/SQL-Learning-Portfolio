USE SqlPracticeDB;
GO

SELECT
    ProductName,
    UnitPrice
FROM dbo.Products
WHERE UnitPrice >
(
    SELECT AVG(UnitPrice)
    FROM dbo.Products
);

SELECT
    FullName
FROM dbo.Customers c
WHERE EXISTS
(
    SELECT 1
    FROM dbo.Orders o
    WHERE o.CustomerID = c.CustomerID
      AND o.Status = 'Completed'
);

SELECT
    FullName
FROM dbo.Customers c
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Orders o
    WHERE o.CustomerID = c.CustomerID
);

SELECT
    ProductName,
    UnitPrice
FROM dbo.Products
WHERE UnitPrice =
(
    SELECT MAX(UnitPrice)
    FROM dbo.Products
);

SELECT
    o.OrderID,
    o.CustomerID,
    o.Quantity
FROM dbo.Orders o
WHERE o.Quantity >
(
    SELECT AVG(CAST(Quantity AS DECIMAL(10,2)))
    FROM dbo.Orders
);
