USE SqlPracticeDB;
GO

DROP VIEW IF EXISTS dbo.vw_CustomerSalesSummary;
DROP VIEW IF EXISTS dbo.vw_OrderPaymentStatus;
GO

CREATE VIEW dbo.vw_CustomerSalesSummary
AS
SELECT
    c.CustomerID,
    c.FullName,
    c.Country,
    c.Segment,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(CASE WHEN o.Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedOrders,
    COALESCE(
        SUM(
            CASE
                WHEN pay.PaymentStatus = 'Paid'
                THEN pay.Amount
                ELSE 0
            END
        ),0
    ) AS PaidAmount
FROM dbo.Customers c
LEFT JOIN dbo.Orders o
    ON o.CustomerID = c.CustomerID
LEFT JOIN dbo.Payments pay
    ON pay.OrderID = o.OrderID
GROUP BY
    c.CustomerID,
    c.FullName,
    c.Country,
    c.Segment;
GO

CREATE VIEW dbo.vw_OrderPaymentStatus
AS
SELECT
    o.OrderID,
    c.FullName,
    p.ProductName,
    o.OrderDate,
    o.Status AS OrderStatus,
    pay.Amount AS PaymentAmount,
    pay.PaymentMethod,
    pay.PaymentStatus
FROM dbo.Orders o
JOIN dbo.Customers c
    ON c.CustomerID = o.CustomerID
JOIN dbo.Products p
    ON p.ProductID = o.ProductID
LEFT JOIN dbo.Payments pay
    ON pay.OrderID = o.OrderID;
GO

SELECT *
FROM dbo.vw_CustomerSalesSummary
ORDER BY PaidAmount DESC;

SELECT *
FROM dbo.vw_OrderPaymentStatus
ORDER BY OrderDate DESC;
