USE SqlPracticeDB;
GO

WITH CustomerPayments AS
(
    SELECT
        c.CustomerID,
        c.FullName,
        COALESCE(SUM(pay.Amount),0) AS PaidAmount
    FROM dbo.Customers c
    LEFT JOIN dbo.Orders o
        ON o.CustomerID = c.CustomerID
    LEFT JOIN dbo.Payments pay
        ON pay.OrderID = o.OrderID
       AND pay.PaymentStatus = 'Paid'
    GROUP BY c.CustomerID, c.FullName
)
SELECT
    *,
    RANK() OVER (ORDER BY PaidAmount DESC) AS RevenueRank
FROM CustomerPayments;

WITH CustomerOrderDates AS
(
    SELECT
        o.OrderID,
        o.CustomerID,
        o.OrderDate,
        LAG(o.OrderDate) OVER
        (
            PARTITION BY o.CustomerID
            ORDER BY o.OrderDate, o.OrderID
        ) AS PreviousOrderDate
    FROM dbo.Orders o
)
SELECT
    OrderID,
    CustomerID,
    OrderDate,
    PreviousOrderDate,
    DATEDIFF(DAY, PreviousOrderDate, OrderDate) AS DaysSincePreviousOrder
FROM CustomerOrderDates
WHERE PreviousOrderDate IS NOT NULL;
