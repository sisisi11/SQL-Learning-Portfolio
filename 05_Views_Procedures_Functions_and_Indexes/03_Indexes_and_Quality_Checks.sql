USE SqlPracticeDB;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Orders_Customer_OrderDate'
      AND object_id = OBJECT_ID('dbo.Orders')
)
BEGIN
    CREATE INDEX IX_Orders_Customer_OrderDate
    ON dbo.Orders(CustomerID, OrderDate)
    INCLUDE (ProductID, Quantity, Status, DiscountPct);
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Payments_Order_Status'
      AND object_id = OBJECT_ID('dbo.Payments')
)
BEGIN
    CREATE INDEX IX_Payments_Order_Status
    ON dbo.Payments(OrderID, PaymentStatus)
    INCLUDE (Amount, PaymentMethod, PaymentDate);
END;
GO

SELECT
    OrderID,
    CustomerID,
    ProductID,
    OrderDate,
    Quantity,
    Status
FROM dbo.Orders
WHERE CustomerID = 2
ORDER BY OrderDate DESC;

SELECT
    'Orders with invalid quantity' AS CheckName,
    COUNT(*) AS IssueCount
FROM dbo.Orders
WHERE Quantity <= 0

UNION ALL

SELECT
    'Orders with discount above 100',
    COUNT(*)
FROM dbo.Orders
WHERE DiscountPct > 100

UNION ALL

SELECT
    'Customers with missing email',
    COUNT(*)
FROM dbo.Customers
WHERE Email IS NULL

UNION ALL

SELECT
    'Payments with non-positive amount',
    COUNT(*)
FROM dbo.Payments
WHERE Amount <= 0

UNION ALL

SELECT
    'Returns with non-positive refund',
    COUNT(*)
FROM dbo.Returns
WHERE RefundAmount <= 0;
GO
