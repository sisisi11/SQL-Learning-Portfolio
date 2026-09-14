USE SqlPracticeDB;
GO

SELECT
    c.CustomerID,
    c.FullName,
    SUM(
        p.UnitPrice * o.Quantity *
        (1 - COALESCE(o.DiscountPct,0) / 100.0)
    ) AS NetOrderValue
FROM dbo.Customers c
JOIN dbo.Orders o
    ON o.CustomerID = c.CustomerID
JOIN dbo.Products p
    ON p.ProductID = o.ProductID
WHERE o.Status = 'Completed'
GROUP BY c.CustomerID, c.FullName
ORDER BY NetOrderValue DESC;

SELECT
    p.Category,
    SUM(p.UnitPrice * o.Quantity) AS GrossRevenue
FROM dbo.Orders o
JOIN dbo.Products p
    ON p.ProductID = o.ProductID
WHERE o.Status = 'Completed'
GROUP BY p.Category
ORDER BY GrossRevenue DESC;

SELECT
    c.Country,
    COUNT(DISTINCT o.OrderID) AS Orders,
    SUM(pay.Amount) AS PaidAmount
FROM dbo.Customers c
JOIN dbo.Orders o
    ON o.CustomerID = c.CustomerID
LEFT JOIN dbo.Payments pay
    ON pay.OrderID = o.OrderID
   AND pay.PaymentStatus = 'Paid'
GROUP BY c.Country
ORDER BY PaidAmount DESC;
