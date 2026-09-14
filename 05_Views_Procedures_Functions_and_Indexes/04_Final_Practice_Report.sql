USE SqlPracticeDB;
GO

WITH CustomerActivity AS
(
    SELECT
        c.CustomerID,
        c.FullName,
        c.Segment,
        COUNT(DISTINCT o.OrderID) AS Orders,
        COALESCE(SUM(pay.Amount),0) AS PaidAmount,
        COUNT(DISTINCT r.ReturnID) AS Returns
    FROM dbo.Customers c
    LEFT JOIN dbo.Orders o
        ON o.CustomerID = c.CustomerID
    LEFT JOIN dbo.Payments pay
        ON pay.OrderID = o.OrderID
       AND pay.PaymentStatus = 'Paid'
    LEFT JOIN dbo.Returns r
        ON r.OrderID = o.OrderID
    GROUP BY
        c.CustomerID,
        c.FullName,
        c.Segment
)
SELECT
    CustomerID,
    FullName,
    Segment,
    Orders,
    PaidAmount,
    Returns,
    RANK() OVER (ORDER BY PaidAmount DESC) AS RevenueRank,
    CASE
        WHEN Returns > 0 THEN 'Review'
        WHEN PaidAmount >= 1000 THEN 'High Value'
        ELSE 'Standard'
    END AS CustomerLabel
FROM CustomerActivity
ORDER BY PaidAmount DESC;
