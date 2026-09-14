USE SqlPracticeDB;
GO

DROP PROCEDURE IF EXISTS dbo.usp_CustomerOrders;
DROP PROCEDURE IF EXISTS dbo.usp_OrdersByStatus;
DROP FUNCTION IF EXISTS dbo.fn_NetOrderValue;
GO

CREATE FUNCTION dbo.fn_NetOrderValue
(
    @UnitPrice DECIMAL(10,2),
    @Quantity INT,
    @DiscountPct DECIMAL(5,2)
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    RETURN
        @UnitPrice * @Quantity *
        (1 - COALESCE(@DiscountPct,0) / 100.0);
END;
GO

CREATE PROCEDURE dbo.usp_CustomerOrders
    @CustomerID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        o.OrderID,
        o.OrderDate,
        p.ProductName,
        o.Quantity,
        p.UnitPrice,
        o.DiscountPct,
        dbo.fn_NetOrderValue
        (
            p.UnitPrice,
            o.Quantity,
            o.DiscountPct
        ) AS NetOrderValue,
        o.Status
    FROM dbo.Orders o
    JOIN dbo.Products p
        ON p.ProductID = o.ProductID
    WHERE o.CustomerID = @CustomerID
    ORDER BY o.OrderDate DESC, o.OrderID DESC;
END;
GO

CREATE PROCEDURE dbo.usp_OrdersByStatus
    @Status VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        o.OrderID,
        c.FullName,
        p.ProductName,
        o.OrderDate,
        o.Status
    FROM dbo.Orders o
    JOIN dbo.Customers c
        ON c.CustomerID = o.CustomerID
    JOIN dbo.Products p
        ON p.ProductID = o.ProductID
    WHERE o.Status = @Status
    ORDER BY o.OrderDate DESC;
END;
GO

EXEC dbo.usp_CustomerOrders @CustomerID = 2;
EXEC dbo.usp_OrdersByStatus @Status = 'Completed';
