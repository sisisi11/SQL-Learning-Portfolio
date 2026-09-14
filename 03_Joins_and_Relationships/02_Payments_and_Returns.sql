USE SqlPracticeDB;
GO

SELECT
    o.OrderID,
    c.FullName,
    pay.Amount,
    pay.PaymentMethod,
    pay.PaymentStatus
FROM dbo.Orders o
JOIN dbo.Customers c
    ON c.CustomerID = o.CustomerID
LEFT JOIN dbo.Payments pay
    ON pay.OrderID = o.OrderID
ORDER BY o.OrderID;

SELECT
    o.OrderID,
    c.FullName,
    p.ProductName,
    r.ReturnDate,
    r.Reason,
    r.RefundAmount
FROM dbo.Returns r
JOIN dbo.Orders o
    ON o.OrderID = r.OrderID
JOIN dbo.Customers c
    ON c.CustomerID = o.CustomerID
JOIN dbo.Products p
    ON p.ProductID = o.ProductID;

SELECT
    c.FullName,
    COUNT(pay.PaymentID) AS Payments,
    SUM(pay.Amount) AS PaidAmount
FROM dbo.Customers c
JOIN dbo.Orders o
    ON o.CustomerID = c.CustomerID
LEFT JOIN dbo.Payments pay
    ON pay.OrderID = o.OrderID
GROUP BY c.FullName
ORDER BY PaidAmount DESC;

SELECT
    pay.PaymentMethod,
    COUNT(*) AS PaymentCount,
    SUM(pay.Amount) AS TotalAmount
FROM dbo.Payments pay
WHERE pay.PaymentStatus = 'Paid'
GROUP BY pay.PaymentMethod
ORDER BY TotalAmount DESC;
