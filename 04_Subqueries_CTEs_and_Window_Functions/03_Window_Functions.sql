USE SqlPracticeDB;
GO

SELECT
    ProductName,
    Category,
    UnitPrice,
    ROW_NUMBER() OVER
    (
        PARTITION BY Category
        ORDER BY UnitPrice DESC
    ) AS RowNum,
    RANK() OVER
    (
        PARTITION BY Category
        ORDER BY UnitPrice DESC
    ) AS PriceRank,
    DENSE_RANK() OVER
    (
        PARTITION BY Category
        ORDER BY UnitPrice DESC
    ) AS DensePriceRank
FROM dbo.Products;

SELECT
    OrderID,
    CustomerID,
    OrderDate,
    LAG(OrderDate) OVER
    (
        PARTITION BY CustomerID
        ORDER BY OrderDate, OrderID
    ) AS PreviousOrderDate
FROM dbo.Orders;

SELECT
    OrderID,
    CustomerID,
    OrderDate,
    LEAD(OrderDate) OVER
    (
        PARTITION BY CustomerID
        ORDER BY OrderDate, OrderID
    ) AS NextOrderDate
FROM dbo.Orders;

SELECT
    PaymentID,
    PaymentDate,
    Amount,
    SUM(Amount) OVER
    (
        ORDER BY PaymentDate, PaymentID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningPaidAmount
FROM dbo.Payments
WHERE PaymentStatus = 'Paid';

WITH RankedCustomerOrders AS
(
    SELECT
        o.CustomerID,
        o.OrderID,
        p.UnitPrice * o.Quantity AS GrossValue,
        ROW_NUMBER() OVER
        (
            PARTITION BY o.CustomerID
            ORDER BY p.UnitPrice * o.Quantity DESC
        ) AS rn
    FROM dbo.Orders o
    JOIN dbo.Products p
        ON p.ProductID = o.ProductID
)
SELECT *
FROM RankedCustomerOrders
WHERE rn <= 2
ORDER BY CustomerID, rn;
