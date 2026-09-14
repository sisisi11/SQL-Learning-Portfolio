USE SqlPracticeDB;
GO

SELECT o.OrderID, c.FullName
FROM dbo.Orders o
JOIN dbo.Customers c ON c.CustomerID = o.CustomerID;

SELECT o.OrderID, p.ProductName
FROM dbo.Orders o
JOIN dbo.Products p ON p.ProductID = o.ProductID;

SELECT c.FullName, o.OrderDate
FROM dbo.Customers c
LEFT JOIN dbo.Orders o ON o.CustomerID = c.CustomerID;

SELECT c.FullName, o.Status
FROM dbo.Customers c
LEFT JOIN dbo.Orders o ON o.CustomerID = c.CustomerID;

SELECT p.ProductName, o.Quantity
FROM dbo.Products p
LEFT JOIN dbo.Orders o ON o.ProductID = p.ProductID;

SELECT p.ProductName
FROM dbo.Products p
LEFT JOIN dbo.Orders o ON o.ProductID = p.ProductID
WHERE o.OrderID IS NULL;

SELECT o.OrderID, pay.Amount
FROM dbo.Orders o
LEFT JOIN dbo.Payments pay ON pay.OrderID = o.OrderID;

SELECT o.OrderID, pay.PaymentMethod
FROM dbo.Orders o
LEFT JOIN dbo.Payments pay ON pay.OrderID = o.OrderID;

SELECT o.OrderID, r.Reason
FROM dbo.Orders o
LEFT JOIN dbo.Returns r ON r.OrderID = o.OrderID;

SELECT o.OrderID
FROM dbo.Orders o
LEFT JOIN dbo.Returns r ON r.OrderID = o.OrderID
WHERE r.ReturnID IS NULL;

SELECT c.FullName, p.ProductName
FROM dbo.Orders o
JOIN dbo.Customers c ON c.CustomerID = o.CustomerID
JOIN dbo.Products p ON p.ProductID = o.ProductID;

SELECT c.FullName, p.ProductName, o.Status
FROM dbo.Orders o
JOIN dbo.Customers c ON c.CustomerID = o.CustomerID
JOIN dbo.Products p ON p.ProductID = o.ProductID
WHERE o.Status = 'Completed';

SELECT c.FullName, pay.Amount
FROM dbo.Customers c
JOIN dbo.Orders o ON o.CustomerID = c.CustomerID
JOIN dbo.Payments pay ON pay.OrderID = o.OrderID;

SELECT c.FullName, r.RefundAmount
FROM dbo.Customers c
JOIN dbo.Orders o ON o.CustomerID = c.CustomerID
JOIN dbo.Returns r ON r.OrderID = o.OrderID;

SELECT c.Country, COUNT(*) AS Orders
FROM dbo.Orders o
JOIN dbo.Customers c ON c.CustomerID = o.CustomerID
GROUP BY c.Country;

SELECT p.Category, SUM(o.Quantity) AS Units
FROM dbo.Orders o
JOIN dbo.Products p ON p.ProductID = o.ProductID
GROUP BY p.Category;

SELECT pay.PaymentMethod, COUNT(*) AS Payments
FROM dbo.Payments pay
GROUP BY pay.PaymentMethod;

SELECT pay.PaymentStatus, SUM(pay.Amount) AS Amount
FROM dbo.Payments pay
GROUP BY pay.PaymentStatus;

SELECT r.Reason, COUNT(*) AS Returns
FROM dbo.Returns r
GROUP BY r.Reason;

SELECT c.Segment, AVG(p.UnitPrice * o.Quantity) AS AvgOrderValue
FROM dbo.Orders o
JOIN dbo.Customers c ON c.CustomerID = o.CustomerID
JOIN dbo.Products p ON p.ProductID = o.ProductID
GROUP BY c.Segment;

SELECT c.FullName, COUNT(o.OrderID) AS Orders
FROM dbo.Customers c
LEFT JOIN dbo.Orders o ON o.CustomerID = c.CustomerID
GROUP BY c.FullName
ORDER BY Orders DESC;

SELECT c.FullName, MAX(o.OrderDate) AS LastOrder
FROM dbo.Customers c
LEFT JOIN dbo.Orders o ON o.CustomerID = c.CustomerID
GROUP BY c.FullName;

SELECT p.ProductName, SUM(pay.Amount) AS PaidAmount
FROM dbo.Products p
JOIN dbo.Orders o ON o.ProductID = p.ProductID
JOIN dbo.Payments pay ON pay.OrderID = o.OrderID
GROUP BY p.ProductName
ORDER BY PaidAmount DESC;
