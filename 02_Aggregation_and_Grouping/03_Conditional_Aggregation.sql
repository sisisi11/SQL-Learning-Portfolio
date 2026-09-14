USE SqlPracticeDB;
GO

SELECT
    COUNT(*) AS TotalOrders,
    SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedOrders,
    SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) AS CancelledOrders,
    SUM(CASE WHEN Status = 'Returned' THEN 1 ELSE 0 END) AS ReturnedOrders
FROM dbo.Orders;

SELECT
    CustomerID,
    COUNT(*) AS TotalOrders,
    SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedOrders
FROM dbo.Orders
GROUP BY CustomerID;

SELECT
    CustomerID,
    SUM(CASE WHEN DiscountPct IS NULL THEN 0 ELSE 1 END) AS DiscountedOrders
FROM dbo.Orders
GROUP BY CustomerID;
