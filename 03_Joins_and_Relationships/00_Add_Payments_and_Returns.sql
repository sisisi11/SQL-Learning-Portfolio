USE SqlPracticeDB;
GO

DROP TABLE IF EXISTS dbo.Returns;
DROP TABLE IF EXISTS dbo.Payments;
GO

CREATE TABLE dbo.Payments
(
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(12,2) NOT NULL,
    PaymentMethod VARCHAR(20) NOT NULL,
    PaymentStatus VARCHAR(20) NOT NULL,

    CONSTRAINT FK_Payments_Orders
        FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID)
);

CREATE TABLE dbo.Returns
(
    ReturnID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ReturnDate DATE NOT NULL,
    Reason VARCHAR(50) NOT NULL,
    RefundAmount DECIMAL(12,2) NOT NULL,

    CONSTRAINT FK_Returns_Orders
        FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID)
);
GO

INSERT INTO dbo.Payments
    (OrderID, PaymentDate, Amount, PaymentMethod, PaymentStatus)
VALUES
(1,'2026-01-10',178.00,'Card','Paid'),
(2,'2026-01-10',56.05,'Card','Paid'),
(3,'2026-01-15',1349.10,'BankTransfer','Paid'),
(4,'2026-01-20',798.00,'Card','Paid'),
(6,'2026-02-03',89.00,'Card','Paid'),
(7,'2026-02-10',474.05,'Card','Paid'),
(8,'2026-02-11',399.00,'Card','Paid'),
(9,'2026-03-01',3822.45,'BankTransfer','Paid'),
(10,'2026-03-01',898.20,'BankTransfer','Paid'),
(11,'2026-03-05',1396.00,'Card','Paid'),
(12,'2026-03-06',295.00,'Card','Paid'),
(13,'2026-03-10',129.00,'Card','Refunded'),
(14,'2026-03-12',253.65,'Card','Paid'),
(15,'2026-03-15',399.00,'Card','Paid'),
(16,'2026-03-20',238.00,'Card','Paid'),
(17,'2026-03-22',179.55,'Card','Paid'),
(18,'2026-03-25',177.00,'Cash','Paid'),
(19,'2026-03-25',89.00,'Cash','Paid');

INSERT INTO dbo.Returns
    (OrderID, ReturnDate, Reason, RefundAmount)
VALUES
(13,'2026-03-12','Changed mind',129.00),
(4,'2026-01-28','Damaged item',399.00);
GO
