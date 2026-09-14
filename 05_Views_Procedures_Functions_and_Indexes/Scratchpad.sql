USE SqlPracticeDB;
GO

SELECT * FROM dbo.vw_CustomerSalesSummary;
SELECT * FROM dbo.vw_CustomerSalesSummary WHERE Segment = 'Premium';
SELECT * FROM dbo.vw_CustomerSalesSummary WHERE PaidAmount > 500;
SELECT * FROM dbo.vw_CustomerSalesSummary ORDER BY PaidAmount DESC;

SELECT * FROM dbo.vw_OrderPaymentStatus;
SELECT * FROM dbo.vw_OrderPaymentStatus WHERE PaymentStatus = 'Paid';
SELECT * FROM dbo.vw_OrderPaymentStatus WHERE PaymentMethod = 'Card';

EXEC dbo.usp_CustomerOrders @CustomerID = 1;
EXEC dbo.usp_CustomerOrders @CustomerID = 2;
EXEC dbo.usp_CustomerOrders @CustomerID = 4;
EXEC dbo.usp_CustomerOrders @CustomerID = 9;

EXEC dbo.usp_OrdersByStatus @Status = 'Completed';
EXEC dbo.usp_OrdersByStatus @Status = 'Returned';
EXEC dbo.usp_OrdersByStatus @Status = 'Cancelled';

SELECT dbo.fn_NetOrderValue(100,2,NULL) AS Test1;
SELECT dbo.fn_NetOrderValue(100,2,10) AS Test2;
SELECT dbo.fn_NetOrderValue(1499,1,15) AS Test3;
SELECT dbo.fn_NetOrderValue(59,5,0) AS Test4;

SELECT * FROM sys.indexes
WHERE object_id = OBJECT_ID('dbo.Orders');

SELECT * FROM sys.indexes
WHERE object_id = OBJECT_ID('dbo.Payments');

SELECT * FROM dbo.Orders
WHERE CustomerID = 1
ORDER BY OrderDate DESC;

SELECT * FROM dbo.Orders
WHERE CustomerID = 5
ORDER BY OrderDate DESC;

SELECT * FROM dbo.Payments
WHERE PaymentStatus = 'Paid';

SELECT * FROM dbo.Payments
WHERE PaymentMethod = 'Card';

SELECT COUNT(*) AS MissingEmails
FROM dbo.Customers
WHERE Email IS NULL;

SELECT COUNT(*) AS InactiveProducts
FROM dbo.Products
WHERE IsActive = 0;

SELECT COUNT(*) AS DiscountedOrders
FROM dbo.Orders
WHERE DiscountPct IS NOT NULL;

SELECT COUNT(*) AS NonCompletedOrders
FROM dbo.Orders
WHERE Status <> 'Completed';

SELECT COUNT(*) AS ReturnedOrders
FROM dbo.Returns;

SELECT SUM(RefundAmount) AS TotalRefunded
FROM dbo.Returns;
