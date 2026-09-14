IF DB_ID('SqlPracticeDB') IS NULL
BEGIN
    CREATE DATABASE SqlPracticeDB;
END;
GO

USE SqlPracticeDB;
GO

DROP TABLE IF EXISTS dbo.Returns;
DROP TABLE IF EXISTS dbo.Payments;
DROP TABLE IF EXISTS dbo.Orders;
DROP TABLE IF EXISTS dbo.Products;
DROP TABLE IF EXISTS dbo.Customers;
GO

CREATE TABLE dbo.Customers
(
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Segment VARCHAR(20) NOT NULL,
    Email VARCHAR(100) NULL,
    CreatedAt DATE NOT NULL
);

CREATE TABLE dbo.Products
(
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

CREATE TABLE dbo.Orders
(
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    OrderDate DATE NOT NULL,
    Quantity INT NOT NULL,
    DiscountPct DECIMAL(5,2) NULL,
    Status VARCHAR(20) NOT NULL,

    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID),

    CONSTRAINT FK_Orders_Products
        FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID),

    CONSTRAINT CK_Orders_Quantity
        CHECK (Quantity > 0)
);
GO

INSERT INTO dbo.Customers
    (FullName, Country, City, Segment, Email, CreatedAt)
VALUES
('Anna Petrova','Bulgaria','Sofia','Retail','anna@example.com','2025-01-10'),
('Ivan Georgiev','Bulgaria','Plovdiv','Premium','ivan@example.com','2025-02-11'),
('Daniel Smith','United Kingdom','London','Retail',NULL,'2025-03-05'),
('Maria Rossi','Italy','Milan','Premium','maria@example.com','2025-03-18'),
('George Brown','Germany','Berlin','Business',NULL,'2025-04-01'),
('Elena Marinova','Bulgaria','Varna','Business','elena@example.com','2025-04-12'),
('Peter Novak','Czech Republic','Prague','Retail',NULL,'2025-05-02'),
('Laura White','Ireland','Dublin','Premium','laura@example.com','2025-05-15'),
('Nikolay Petrov','Bulgaria','Sofia','Retail','nikolay@example.com','2025-06-01'),
('Emma Jones','United Kingdom','Manchester','Business',NULL,'2025-06-18');

INSERT INTO dbo.Products
    (ProductName, Category, UnitPrice, IsActive)
VALUES
('Laptop','Electronics',1499.00,1),
('Monitor','Electronics',399.00,1),
('Keyboard','Accessories',89.00,1),
('Office Chair','Furniture',349.00,1),
('Desk','Furniture',499.00,1),
('Mouse','Accessories',59.00,1),
('Webcam','Electronics',129.00,1),
('Old Printer','Electronics',199.00,0),
('Headset','Accessories',119.00,1),
('Docking Station','Accessories',189.00,1);

INSERT INTO dbo.Orders
    (CustomerID, ProductID, OrderDate, Quantity, DiscountPct, Status)
VALUES
(1,3,'2026-01-10',2,NULL,'Completed'),
(1,6,'2026-01-10',1,5,'Completed'),
(2,1,'2026-01-15',1,10,'Completed'),
(2,2,'2026-01-20',2,NULL,'Completed'),
(3,4,'2026-02-01',1,NULL,'Cancelled'),
(3,3,'2026-02-03',1,NULL,'Completed'),
(4,5,'2026-02-10',1,5,'Completed'),
(4,2,'2026-02-11',1,NULL,'Completed'),
(5,1,'2026-03-01',3,15,'Completed'),
(5,5,'2026-03-01',2,10,'Completed'),
(6,4,'2026-03-05',4,NULL,'Completed'),
(6,6,'2026-03-06',5,NULL,'Completed'),
(2,7,'2026-03-10',1,NULL,'Returned'),
(4,3,'2026-03-12',3,5,'Completed'),
(1,2,'2026-03-15',1,NULL,'Completed'),
(7,9,'2026-03-20',2,NULL,'Completed'),
(8,10,'2026-03-22',1,5,'Completed'),
(9,6,'2026-03-25',3,NULL,'Completed'),
(9,3,'2026-03-25',1,NULL,'Completed');
GO
