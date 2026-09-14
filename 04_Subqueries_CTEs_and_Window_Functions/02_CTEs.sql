USE SqlPracticeDB;
GO

WITH OrderValues AS
(
    SELECT
        o.OrderID,
        o.CustomerID,
        p.UnitPrice * o.Quantity AS GrossValue
    FROM dbo.Orders o
    JOIN dbo.Products p
        ON p.ProductID = o.ProductID
    WHERE o.Status = 'Completed'
)
SELECT
    CustomerID,
    COUNT(*) AS CompletedOrders,
    SUM(GrossValue) AS TotalValue
FROM OrderValues
GROUP BY CustomerID;

WITH PaidOrders AS
(
    SELECT
        o.OrderID,
        o.CustomerID,
        pay.Amount
    FROM dbo.Orders o
    JOIN dbo.Payments pay
        ON pay.OrderID = o.OrderID
    WHERE pay.PaymentStatus = 'Paid'
)
SELECT
    CustomerID,
    COUNT(*) AS PaidOrders,
    SUM(Amount) AS PaidAmount
FROM PaidOrders
GROUP BY CustomerID
ORDER BY PaidAmount DESC;

WITH CustomerRevenue AS
(
    SELECT
        c.CustomerID,
        c.FullName,
        COALESCE(SUM(pay.Amount),0) AS Revenue
    FROM dbo.Customers c
    LEFT JOIN dbo.Orders o
        ON o.CustomerID = c.CustomerID
    LEFT JOIN dbo.Payments pay
        ON pay.OrderID = o.OrderID
       AND pay.PaymentStatus = 'Paid'
    GROUP BY c.CustomerID, c.FullName
),
AverageRevenue AS
(
    SELECT AVG(Revenue) AS AvgRevenue
    FROM CustomerRevenue
)
SELECT
    cr.CustomerID,
    cr.FullName,
    cr.Revenue,
    ar.AvgRevenue,
    cr.Revenue - ar.AvgRevenue AS DifferenceFromAverage
FROM CustomerRevenue cr
CROSS JOIN AverageRevenue ar
ORDER BY cr.Revenue DESC;
