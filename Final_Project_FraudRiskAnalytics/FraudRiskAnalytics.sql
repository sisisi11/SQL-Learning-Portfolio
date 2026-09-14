/*
================================================================================
PROJECT: Fraud Detection & Transaction Risk Analytics
DATABASE: Microsoft SQL Server (T-SQL)
AUTHOR: Portfolio Project
PURPOSE:
    Demonstrate strong SQL skills in a realistic fraud/risk analytics scenario.

IMPORTANT:
    - All data in this project is synthetic.
    - This is a portfolio / learning project, not production banking software.
================================================================================
*/

-- ============================================================================
-- 0. CREATE DATABASE
-- ============================================================================
IF DB_ID('FraudRiskAnalytics') IS NULL
BEGIN
    CREATE DATABASE FraudRiskAnalytics;
END;
GO

USE FraudRiskAnalytics;
GO

-- ============================================================================
-- 1. CLEAN UP (SAFE RE-RUN)
-- ============================================================================
DROP VIEW IF EXISTS dbo.vw_RiskDashboard;
DROP VIEW IF EXISTS dbo.vw_HighRiskTransactions;
DROP PROCEDURE IF EXISTS dbo.usp_InvestigateCustomer;
DROP FUNCTION IF EXISTS dbo.fn_CustomerRiskScore;

DROP TABLE IF EXISTS dbo.FraudAlerts;
DROP TABLE IF EXISTS dbo.Transactions;
DROP TABLE IF EXISTS dbo.CustomerDevices;
DROP TABLE IF EXISTS dbo.Customers;
GO

-- ============================================================================
-- 2. CORE TABLES
-- ============================================================================

CREATE TABLE dbo.Customers
(
    CustomerID          INT IDENTITY(1,1) PRIMARY KEY,
    FullName            NVARCHAR(100) NOT NULL,
    CountryCode         CHAR(2) NOT NULL,
    Segment             VARCHAR(20) NOT NULL,
    RiskTier            VARCHAR(10) NOT NULL,
    DateOfBirth         DATE NULL,
    CreatedAt           DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT CK_Customers_Segment
        CHECK (Segment IN ('Retail','Premium','Business')),

    CONSTRAINT CK_Customers_RiskTier
        CHECK (RiskTier IN ('Low','Medium','High'))
);
GO

CREATE TABLE dbo.CustomerDevices
(
    DeviceID            INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID          INT NOT NULL,
    DeviceFingerprint   VARCHAR(64) NOT NULL,
    DeviceType          VARCHAR(20) NOT NULL,
    FirstSeenAt         DATETIME2(0) NOT NULL,
    LastSeenAt          DATETIME2(0) NOT NULL,
    IsTrusted           BIT NOT NULL DEFAULT 0,

    CONSTRAINT FK_CustomerDevices_Customers
        FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID),

    CONSTRAINT UQ_CustomerDevices_Fingerprint
        UNIQUE (CustomerID, DeviceFingerprint)
);
GO

CREATE TABLE dbo.Transactions
(
    TransactionID       BIGINT IDENTITY(1,1) PRIMARY KEY,
    CustomerID          INT NOT NULL,
    DeviceID            INT NULL,
    TransactionTime     DATETIME2(0) NOT NULL,
    Amount              DECIMAL(18,2) NOT NULL,
    CurrencyCode        CHAR(3) NOT NULL,
    MerchantCountry     CHAR(2) NOT NULL,
    Channel             VARCHAR(20) NOT NULL,
    TransactionType     VARCHAR(20) NOT NULL,
    Status              VARCHAR(20) NOT NULL,
    IPAddress           VARCHAR(45) NULL,

    CONSTRAINT FK_Transactions_Customers
        FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID),

    CONSTRAINT FK_Transactions_Devices
        FOREIGN KEY (DeviceID) REFERENCES dbo.CustomerDevices(DeviceID),

    CONSTRAINT CK_Transactions_Amount
        CHECK (Amount > 0),

    CONSTRAINT CK_Transactions_Channel
        CHECK (Channel IN ('Web','Mobile','POS','ATM')),

    CONSTRAINT CK_Transactions_Type
        CHECK (TransactionType IN ('Purchase','Transfer','Withdrawal')),

    CONSTRAINT CK_Transactions_Status
        CHECK (Status IN ('Approved','Declined','Reversed'))
);
GO

CREATE TABLE dbo.FraudAlerts
(
    AlertID             BIGINT IDENTITY(1,1) PRIMARY KEY,
    TransactionID       BIGINT NOT NULL,
    RuleCode            VARCHAR(50) NOT NULL,
    RuleDescription     VARCHAR(250) NOT NULL,
    RiskPoints          INT NOT NULL,
    Severity            VARCHAR(10) NOT NULL,
    CreatedAt           DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_FraudAlerts_Transactions
        FOREIGN KEY (TransactionID) REFERENCES dbo.Transactions(TransactionID),

    CONSTRAINT CK_FraudAlerts_RiskPoints
        CHECK (RiskPoints BETWEEN 0 AND 100),

    CONSTRAINT CK_FraudAlerts_Severity
        CHECK (Severity IN ('Low','Medium','High','Critical'))
);
GO

-- ============================================================================
-- 3. SYNTHETIC CUSTOMERS
-- ============================================================================

INSERT INTO dbo.Customers
    (FullName, CountryCode, Segment, RiskTier, DateOfBirth)
VALUES
('Alex Morgan',     'GB', 'Premium',  'Low',    '1988-05-18'),
('Maria Ivanova',   'BG', 'Retail',   'Medium', '1992-11-03'),
('Daniel Rossi',    'IT', 'Premium',  'Low',    '1985-02-14'),
('Sofia Petrov',    'BG', 'Retail',   'High',   '1998-07-22'),
('James Carter',    'US', 'Business', 'Medium', '1981-09-30'),
('Elena Georgieva', 'BG', 'Premium',  'Medium', '1990-04-05'),
('Noah Schmidt',    'DE', 'Retail',   'Low',    '1995-01-11'),
('Victor Marin',    'RO', 'Business', 'High',   '1983-12-20');
GO

-- ============================================================================
-- 4. DEVICES
-- ============================================================================

INSERT INTO dbo.CustomerDevices
    (CustomerID, DeviceFingerprint, DeviceType, FirstSeenAt, LastSeenAt, IsTrusted)
VALUES
(1,'DEV-A1','Desktop','2026-01-10','2026-09-01',1),
(2,'DEV-B2','Mobile', '2026-02-01','2026-09-02',1),
(3,'DEV-C3','Desktop','2026-03-15','2026-09-03',1),
(4,'DEV-D4','Mobile', '2026-05-01','2026-09-04',1),
(4,'DEV-X9','Desktop','2026-09-04','2026-09-04',0),
(5,'DEV-E5','Desktop','2026-04-10','2026-09-05',1),
(6,'DEV-F6','Mobile', '2026-06-11','2026-09-06',1),
(7,'DEV-G7','Mobile', '2026-07-12','2026-09-08',1),
(8,'DEV-H8','Mobile', '2026-02-20','2026-09-09',1),
(8,'DEV-Z1','Desktop','2026-09-09','2026-09-09',0);
GO

-- ============================================================================
-- 5. TRANSACTIONS
-- ============================================================================

INSERT INTO dbo.Transactions
(CustomerID, DeviceID, TransactionTime, Amount, CurrencyCode, MerchantCountry,
 Channel, TransactionType, Status, IPAddress)
VALUES
-- normal baseline customer
(1,1,'2026-09-01 09:15',  42.50,'GBP','GB','Web',   'Purchase',  'Approved','81.20.10.1'),
(1,1,'2026-09-01 09:42',  38.90,'GBP','GB','Web',   'Purchase',  'Approved','81.20.10.1'),
(1,1,'2026-09-01 10:05',  55.20,'GBP','GB','Mobile','Purchase',  'Approved','81.20.10.1'),
(1,1,'2026-09-01 13:20',  49.00,'GBP','GB','Web',   'Purchase',  'Approved','81.20.10.1'),

-- moderate-risk customer with decline
(2,2,'2026-09-02 12:10', 120.00,'EUR','BG','POS','Purchase','Approved','92.10.1.2'),
(2,2,'2026-09-02 12:16', 115.00,'EUR','BG','POS','Purchase','Approved','92.10.1.2'),
(2,2,'2026-09-02 12:20', 130.00,'EUR','BG','POS','Purchase','Declined','92.10.1.2'),
(2,2,'2026-09-02 12:23', 135.00,'EUR','BG','POS','Purchase','Declined','92.10.1.2'),

-- normal customer
(3,3,'2026-09-03 18:20',  75.00,'EUR','IT','Web','Purchase','Approved','151.2.4.3'),
(3,3,'2026-09-03 18:55',  91.00,'EUR','IT','Web','Purchase','Approved','151.2.4.3'),
(3,3,'2026-09-03 19:40',  84.00,'EUR','IT','Web','Purchase','Approved','151.2.4.3'),

-- suspicious velocity / device change / foreign country
(4,4,'2026-09-04 01:10', 900.00,'EUR','BG','Web','Transfer','Approved','87.100.4.5'),
(4,4,'2026-09-04 01:14', 950.00,'EUR','BG','Web','Transfer','Approved','87.100.4.5'),
(4,4,'2026-09-04 01:17', 980.00,'EUR','BG','Web','Transfer','Approved','87.100.4.5'),
(4,5,'2026-09-04 02:02',1200.00,'EUR','DE','Web','Transfer','Approved','45.9.8.7'),

-- high value customer
(5,6,'2026-09-05 14:10',4500.00,'USD','US','Web','Transfer','Approved','22.5.6.7'),
(5,6,'2026-09-05 14:14',4700.00,'USD','US','Web','Transfer','Approved','22.5.6.7'),

-- rapid micro-purchases
(6,7,'2026-09-06 08:00',  19.99,'EUR','BG','Mobile','Purchase','Approved','91.1.1.1'),
(6,7,'2026-09-06 08:01',  21.99,'EUR','BG','Mobile','Purchase','Approved','91.1.1.1'),
(6,7,'2026-09-06 08:02',  24.99,'EUR','BG','Mobile','Purchase','Approved','91.1.1.1'),
(6,7,'2026-09-06 08:03',  29.99,'EUR','BG','Mobile','Purchase','Approved','91.1.1.1'),
(6,7,'2026-09-06 08:04',  35.99,'EUR','BG','Mobile','Purchase','Approved','91.1.1.1'),

-- normal customer
(7,8,'2026-09-07 16:40',  60.00,'EUR','DE','POS','Purchase','Approved','80.2.2.2'),
(7,8,'2026-09-08 16:40',  65.00,'EUR','DE','POS','Purchase','Approved','80.2.2.2'),

-- rapid ATM + new device + country change
(8,9,'2026-09-09 03:05', 700.00,'EUR','RO','ATM','Withdrawal','Approved','79.3.3.3'),
(8,9,'2026-09-09 03:07', 700.00,'EUR','RO','ATM','Withdrawal','Approved','79.3.3.3'),
(8,9,'2026-09-09 03:09', 700.00,'EUR','RO','ATM','Withdrawal','Approved','79.3.3.3'),
(8,10,'2026-09-09 03:30',900.00,'EUR','BG','Web','Transfer','Approved','212.4.4.4');
GO

-- ============================================================================
-- 6. INDEXING STRATEGY
-- ============================================================================

CREATE INDEX IX_Transactions_CustomerTime
ON dbo.Transactions(CustomerID, TransactionTime)
INCLUDE (Amount, Status, MerchantCountry, DeviceID, TransactionType);
GO

CREATE INDEX IX_Transactions_DeviceTime
ON dbo.Transactions(DeviceID, TransactionTime)
INCLUDE (CustomerID, Amount, MerchantCountry);
GO

CREATE INDEX IX_Transactions_StatusTime
ON dbo.Transactions(Status, TransactionTime)
INCLUDE (CustomerID, Amount);
GO

CREATE INDEX IX_FraudAlerts_TransactionID
ON dbo.FraudAlerts(TransactionID);
GO

-- ============================================================================
-- 7. ANALYTICS QUERY #1
--    CUSTOMER TRANSACTION SUMMARY
-- ============================================================================

SELECT
    c.CustomerID,
    c.FullName,
    c.RiskTier,
    COUNT(t.TransactionID) AS TransactionCount,
    SUM(CASE WHEN t.Status = 'Approved' THEN 1 ELSE 0 END) AS ApprovedCount,
    SUM(CASE WHEN t.Status = 'Declined' THEN 1 ELSE 0 END) AS DeclinedCount,
    SUM(CASE WHEN t.Status = 'Approved' THEN t.Amount ELSE 0 END) AS ApprovedVolume,
    CAST(AVG(t.Amount) AS DECIMAL(18,2)) AS AverageTransaction
FROM dbo.Customers c
LEFT JOIN dbo.Transactions t
    ON t.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FullName, c.RiskTier
ORDER BY ApprovedVolume DESC;
GO

-- ============================================================================
-- 8. ANALYTICS QUERY #2
--    VELOCITY DETECTION: >= 4 TRANSACTIONS IN 10 MINUTES
-- ============================================================================

SELECT
    t1.TransactionID,
    t1.CustomerID,
    c.FullName,
    t1.TransactionTime,
    COUNT(t2.TransactionID) AS TransactionsWithin10Minutes,
    SUM(t2.Amount) AS VolumeWithin10Minutes
FROM dbo.Transactions t1
JOIN dbo.Transactions t2
    ON t2.CustomerID = t1.CustomerID
   AND t2.TransactionTime BETWEEN DATEADD(MINUTE,-10,t1.TransactionTime)
                              AND t1.TransactionTime
JOIN dbo.Customers c
    ON c.CustomerID = t1.CustomerID
GROUP BY
    t1.TransactionID,
    t1.CustomerID,
    c.FullName,
    t1.TransactionTime
HAVING COUNT(t2.TransactionID) >= 4
ORDER BY TransactionsWithin10Minutes DESC, t1.TransactionTime;
GO

-- ============================================================================
-- 9. ANALYTICS QUERY #3
--    RAPID TRANSACTION SEQUENCES USING LAG()
-- ============================================================================

WITH SequencedTransactions AS
(
    SELECT
        t.TransactionID,
        t.CustomerID,
        t.TransactionTime,
        t.Amount,
        t.TransactionType,
        LAG(t.TransactionTime)
            OVER (PARTITION BY t.CustomerID ORDER BY t.TransactionTime) AS PreviousTime,
        LAG(t.Amount)
            OVER (PARTITION BY t.CustomerID ORDER BY t.TransactionTime) AS PreviousAmount
    FROM dbo.Transactions t
)
SELECT
    st.TransactionID,
    st.CustomerID,
    c.FullName,
    st.TransactionTime,
    st.Amount,
    st.PreviousTime,
    DATEDIFF(SECOND, st.PreviousTime, st.TransactionTime) AS SecondsSincePrevious,
    st.PreviousAmount
FROM SequencedTransactions st
JOIN dbo.Customers c
    ON c.CustomerID = st.CustomerID
WHERE st.PreviousTime IS NOT NULL
  AND DATEDIFF(SECOND, st.PreviousTime, st.TransactionTime) <= 120
ORDER BY st.CustomerID, st.TransactionTime;
GO

-- ============================================================================
-- 10. ANALYTICS QUERY #4
--     DEVICE / COUNTRY SWITCHING
-- ============================================================================

WITH OrderedTransactions AS
(
    SELECT
        t.TransactionID,
        t.CustomerID,
        t.TransactionTime,
        t.MerchantCountry,
        t.DeviceID,
        LAG(t.MerchantCountry)
            OVER (PARTITION BY t.CustomerID ORDER BY t.TransactionTime) AS PreviousCountry,
        LAG(t.DeviceID)
            OVER (PARTITION BY t.CustomerID ORDER BY t.TransactionTime) AS PreviousDevice,
        LAG(t.TransactionTime)
            OVER (PARTITION BY t.CustomerID ORDER BY t.TransactionTime) AS PreviousTime
    FROM dbo.Transactions t
)
SELECT
    ot.TransactionID,
    ot.CustomerID,
    c.FullName,
    ot.TransactionTime,
    ot.MerchantCountry,
    ot.PreviousCountry,
    ot.DeviceID,
    ot.PreviousDevice,
    DATEDIFF(MINUTE, ot.PreviousTime, ot.TransactionTime) AS MinutesSincePrevious
FROM OrderedTransactions ot
JOIN dbo.Customers c
    ON c.CustomerID = ot.CustomerID
WHERE ot.PreviousTime IS NOT NULL
  AND (
        ot.MerchantCountry <> ot.PreviousCountry
        OR ISNULL(ot.DeviceID,-1) <> ISNULL(ot.PreviousDevice,-1)
      )
  AND DATEDIFF(MINUTE, ot.PreviousTime, ot.TransactionTime) <= 120
ORDER BY ot.TransactionTime;
GO

-- ============================================================================
-- 11. ANALYTICS QUERY #5
--     CUSTOMER-LEVEL Z-SCORE-LIKE AMOUNT ANOMALY
--     (Uses rolling historical average/std dev concept)
-- ============================================================================

WITH CustomerAmountStats AS
(
    SELECT
        CustomerID,
        AVG(CAST(Amount AS FLOAT)) AS AvgAmount,
        STDEV(CAST(Amount AS FLOAT)) AS StdAmount
    FROM dbo.Transactions
    WHERE Status = 'Approved'
    GROUP BY CustomerID
)
SELECT
    t.TransactionID,
    t.CustomerID,
    c.FullName,
    t.Amount,
    CAST(s.AvgAmount AS DECIMAL(18,2)) AS CustomerAvgAmount,
    CAST(s.StdAmount AS DECIMAL(18,2)) AS CustomerStdDev,
    CASE
        WHEN s.StdAmount IS NULL OR s.StdAmount = 0 THEN NULL
        ELSE CAST((t.Amount - s.AvgAmount) / s.StdAmount AS DECIMAL(10,2))
    END AS AmountZScore
FROM dbo.Transactions t
JOIN CustomerAmountStats s
    ON s.CustomerID = t.CustomerID
JOIN dbo.Customers c
    ON c.CustomerID = t.CustomerID
WHERE t.Status = 'Approved'
ORDER BY ABS(
    CASE
        WHEN s.StdAmount IS NULL OR s.StdAmount = 0 THEN 0
        ELSE (t.Amount - s.AvgAmount) / s.StdAmount
    END
) DESC;
GO

-- ============================================================================
-- 12. ANALYTICS QUERY #6
--     TOP 3 TRANSACTIONS PER CUSTOMER (ROW_NUMBER)
-- ============================================================================

WITH RankedTransactions AS
(
    SELECT
        t.*,
        ROW_NUMBER() OVER
        (
            PARTITION BY t.CustomerID
            ORDER BY t.Amount DESC, t.TransactionTime DESC
        ) AS rn
    FROM dbo.Transactions t
)
SELECT
    rt.CustomerID,
    c.FullName,
    rt.TransactionID,
    rt.TransactionTime,
    rt.Amount,
    rt.TransactionType,
    rt.MerchantCountry
FROM RankedTransactions rt
JOIN dbo.Customers c
    ON c.CustomerID = rt.CustomerID
WHERE rt.rn <= 3
ORDER BY rt.CustomerID, rt.rn;
GO

-- ============================================================================
-- 13. INLINE TABLE-VALUED FUNCTION
--     CUSTOMER RISK SCORE
-- ============================================================================

CREATE FUNCTION dbo.fn_CustomerRiskScore(@CustomerID INT)
RETURNS TABLE
AS
RETURN
(
    WITH Stats AS
    (
        SELECT
            c.CustomerID,
            c.FullName,
            c.RiskTier,
            COUNT(t.TransactionID) AS TxCount,
            COALESCE(SUM(t.Amount),0) AS TotalVolume,
            COALESCE(AVG(t.Amount),0) AS AvgAmount,
            SUM(CASE WHEN t.Status = 'Declined' THEN 1 ELSE 0 END) AS DeclinedCount,
            COUNT(DISTINCT t.DeviceID) AS DeviceCount,
            COUNT(DISTINCT t.MerchantCountry) AS CountryCount,
            SUM(CASE WHEN t.TransactionType = 'Withdrawal' THEN 1 ELSE 0 END) AS WithdrawalCount
        FROM dbo.Customers c
        LEFT JOIN dbo.Transactions t
            ON t.CustomerID = c.CustomerID
        WHERE c.CustomerID = @CustomerID
        GROUP BY c.CustomerID, c.FullName, c.RiskTier
    )
    SELECT
        CustomerID,
        FullName,
        RiskTier,
        TxCount,
        TotalVolume,
        AvgAmount,
        DeclinedCount,
        DeviceCount,
        CountryCount,
        WithdrawalCount,
        (
            CASE WHEN DeclinedCount >= 2 THEN 20 ELSE 0 END +
            CASE WHEN DeviceCount >= 2 THEN 15 ELSE 0 END +
            CASE WHEN CountryCount >= 2 THEN 20 ELSE 0 END +
            CASE WHEN AvgAmount >= 500 THEN 20 ELSE 0 END +
            CASE WHEN WithdrawalCount >= 3 THEN 10 ELSE 0 END +
            CASE
                WHEN RiskTier = 'High' THEN 15
                WHEN RiskTier = 'Medium' THEN 7
                ELSE 0
            END
        ) AS RiskScore
    FROM Stats
);
GO

-- Example:
SELECT * FROM dbo.fn_CustomerRiskScore(4);
GO

-- ============================================================================
-- 14. VIEW: HIGH-RISK TRANSACTIONS
-- ============================================================================

CREATE VIEW dbo.vw_HighRiskTransactions
AS
SELECT
    t.TransactionID,
    c.CustomerID,
    c.FullName,
    c.RiskTier,
    t.TransactionTime,
    t.Amount,
    t.CurrencyCode,
    t.MerchantCountry,
    t.Channel,
    t.DeviceID,
    d.IsTrusted,
    t.TransactionType,
    t.Status
FROM dbo.Transactions t
JOIN dbo.Customers c
    ON c.CustomerID = t.CustomerID
LEFT JOIN dbo.CustomerDevices d
    ON d.DeviceID = t.DeviceID
WHERE
       t.Amount >= 900
    OR c.RiskTier = 'High'
    OR d.IsTrusted = 0
    OR t.TransactionType = 'Withdrawal';
GO

-- ============================================================================
-- 15. VIEW: DASHBOARD-READY CUSTOMER RISK SUMMARY
-- ============================================================================

CREATE VIEW dbo.vw_RiskDashboard
AS
SELECT
    c.CustomerID,
    c.FullName,
    c.CountryCode,
    c.Segment,
    c.RiskTier,
    COUNT(t.TransactionID) AS TransactionCount,
    COALESCE(SUM(t.Amount),0) AS TotalVolume,
    COALESCE(AVG(t.Amount),0) AS AverageAmount,
    COUNT(DISTINCT t.DeviceID) AS DeviceCount,
    COUNT(DISTINCT t.MerchantCountry) AS CountryCount,
    SUM(CASE WHEN t.Status = 'Declined' THEN 1 ELSE 0 END) AS DeclinedCount,
    SUM(CASE WHEN d.IsTrusted = 0 THEN 1 ELSE 0 END) AS UntrustedDeviceTransactions
FROM dbo.Customers c
LEFT JOIN dbo.Transactions t
    ON t.CustomerID = c.CustomerID
LEFT JOIN dbo.CustomerDevices d
    ON d.DeviceID = t.DeviceID
GROUP BY
    c.CustomerID,
    c.FullName,
    c.CountryCode,
    c.Segment,
    c.RiskTier;
GO

-- ============================================================================
-- 16. STORED PROCEDURE: CUSTOMER INVESTIGATION
-- ============================================================================

CREATE PROCEDURE dbo.usp_InvestigateCustomer
    @CustomerID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- customer summary
    SELECT *
    FROM dbo.fn_CustomerRiskScore(@CustomerID);

    -- full transaction timeline
    SELECT
        t.TransactionID,
        t.TransactionTime,
        t.Amount,
        t.CurrencyCode,
        t.MerchantCountry,
        t.Channel,
        t.TransactionType,
        t.Status,
        d.DeviceFingerprint,
        d.IsTrusted,
        t.IPAddress
    FROM dbo.Transactions t
    LEFT JOIN dbo.CustomerDevices d
        ON d.DeviceID = t.DeviceID
    WHERE t.CustomerID = @CustomerID
    ORDER BY t.TransactionTime DESC;

    -- linked fraud alerts
    SELECT
        fa.AlertID,
        fa.RuleCode,
        fa.RuleDescription,
        fa.RiskPoints,
        fa.Severity,
        fa.CreatedAt
    FROM dbo.FraudAlerts fa
    JOIN dbo.Transactions t
        ON t.TransactionID = fa.TransactionID
    WHERE t.CustomerID = @CustomerID
    ORDER BY fa.CreatedAt DESC;
END;
GO

-- Example:
EXEC dbo.usp_InvestigateCustomer @CustomerID = 4;
GO

-- ============================================================================
-- 17. CREATE FRAUD ALERTS
--     Rule 1: high amount
-- ============================================================================

INSERT INTO dbo.FraudAlerts
(TransactionID, RuleCode, RuleDescription, RiskPoints, Severity)
SELECT
    t.TransactionID,
    'HIGH_AMOUNT',
    'Transaction amount is at least 1000 units.',
    25,
    'High'
FROM dbo.Transactions t
WHERE t.Amount >= 1000
  AND NOT EXISTS
  (
      SELECT 1
      FROM dbo.FraudAlerts fa
      WHERE fa.TransactionID = t.TransactionID
        AND fa.RuleCode = 'HIGH_AMOUNT'
  );
GO

-- Rule 2: untrusted device
INSERT INTO dbo.FraudAlerts
(TransactionID, RuleCode, RuleDescription, RiskPoints, Severity)
SELECT
    t.TransactionID,
    'NEW_DEVICE',
    'Transaction originated from an untrusted or newly observed device.',
    25,
    'High'
FROM dbo.Transactions t
JOIN dbo.CustomerDevices d
    ON d.DeviceID = t.DeviceID
WHERE d.IsTrusted = 0
  AND NOT EXISTS
  (
      SELECT 1
      FROM dbo.FraudAlerts fa
      WHERE fa.TransactionID = t.TransactionID
        AND fa.RuleCode = 'NEW_DEVICE'
  );
GO

-- Rule 3: rapid sequence
WITH TxSequence AS
(
    SELECT
        t.TransactionID,
        t.CustomerID,
        t.TransactionTime,
        LAG(t.TransactionTime)
            OVER (PARTITION BY t.CustomerID ORDER BY t.TransactionTime) AS PreviousTime
    FROM dbo.Transactions t
)
INSERT INTO dbo.FraudAlerts
(TransactionID, RuleCode, RuleDescription, RiskPoints, Severity)
SELECT
    s.TransactionID,
    'RAPID_SEQUENCE',
    'Transaction occurred within 120 seconds of the previous customer transaction.',
    15,
    'Medium'
FROM TxSequence s
WHERE s.PreviousTime IS NOT NULL
  AND DATEDIFF(SECOND, s.PreviousTime, s.TransactionTime) <= 120
  AND NOT EXISTS
  (
      SELECT 1
      FROM dbo.FraudAlerts fa
      WHERE fa.TransactionID = s.TransactionID
        AND fa.RuleCode = 'RAPID_SEQUENCE'
  );
GO

-- ============================================================================
-- 18. RISK REPORT: ALERTS PER CUSTOMER
-- ============================================================================

SELECT
    c.CustomerID,
    c.FullName,
    COUNT(DISTINCT t.TransactionID) AS AlertedTransactions,
    COUNT(fa.AlertID) AS TotalAlerts,
    SUM(fa.RiskPoints) AS TotalRiskPoints,
    MAX(
        CASE fa.Severity
            WHEN 'Critical' THEN 4
            WHEN 'High' THEN 3
            WHEN 'Medium' THEN 2
            WHEN 'Low' THEN 1
            ELSE 0
        END
    ) AS MaxSeverityRank
FROM dbo.Customers c
JOIN dbo.Transactions t
    ON t.CustomerID = c.CustomerID
JOIN dbo.FraudAlerts fa
    ON fa.TransactionID = t.TransactionID
GROUP BY c.CustomerID, c.FullName
ORDER BY TotalRiskPoints DESC;
GO

-- ============================================================================
-- 19. DECLINE RATE
-- ============================================================================

SELECT
    c.CustomerID,
    c.FullName,
    COUNT(t.TransactionID) AS TotalTransactions,
    SUM(CASE WHEN t.Status = 'Declined' THEN 1 ELSE 0 END) AS DeclinedTransactions,
    CAST(
        100.0 * SUM(CASE WHEN t.Status = 'Declined' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(t.TransactionID),0)
        AS DECIMAL(6,2)
    ) AS DeclineRatePct
FROM dbo.Customers c
JOIN dbo.Transactions t
    ON t.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FullName
HAVING COUNT(t.TransactionID) >= 2
ORDER BY DeclineRatePct DESC;
GO

-- ============================================================================
-- 20. CONTRIBUTION TO TOTAL VOLUME BY RISK TIER
-- ============================================================================

WITH RiskTierVolume AS
(
    SELECT
        c.RiskTier,
        SUM(t.Amount) AS TierVolume
    FROM dbo.Customers c
    JOIN dbo.Transactions t
        ON t.CustomerID = c.CustomerID
    WHERE t.Status = 'Approved'
    GROUP BY c.RiskTier
),
TotalVolume AS
(
    SELECT SUM(TierVolume) AS GrandTotal
    FROM RiskTierVolume
)
SELECT
    r.RiskTier,
    r.TierVolume,
    CAST(100.0 * r.TierVolume / NULLIF(t.GrandTotal,0) AS DECIMAL(6,2))
        AS PercentOfApprovedVolume
FROM RiskTierVolume r
CROSS JOIN TotalVolume t
ORDER BY r.TierVolume DESC;
GO

-- ============================================================================
-- 21. DATA QUALITY CHECKS
-- ============================================================================

SELECT
    'Transactions with non-positive amounts' AS CheckName,
    COUNT(*) AS IssueCount
FROM dbo.Transactions
WHERE Amount <= 0

UNION ALL

SELECT
    'Transactions without customer',
    COUNT(*)
FROM dbo.Transactions t
LEFT JOIN dbo.Customers c
    ON c.CustomerID = t.CustomerID
WHERE c.CustomerID IS NULL

UNION ALL

SELECT
    'Transactions in the future',
    COUNT(*)
FROM dbo.Transactions
WHERE TransactionTime > SYSUTCDATETIME()

UNION ALL

SELECT
    'Trusted devices with invalid dates',
    COUNT(*)
FROM dbo.CustomerDevices
WHERE LastSeenAt < FirstSeenAt;
GO

-- ============================================================================
-- 22. FINAL DASHBOARD QUERIES
-- ============================================================================

SELECT *
FROM dbo.vw_RiskDashboard
ORDER BY TotalVolume DESC;
GO

SELECT *
FROM dbo.vw_HighRiskTransactions
ORDER BY TransactionTime DESC;
GO

SELECT
    fa.RuleCode,
    COUNT(*) AS AlertCount,
    SUM(fa.RiskPoints) AS TotalRiskPoints
FROM dbo.FraudAlerts fa
GROUP BY fa.RuleCode
ORDER BY AlertCount DESC;
GO

/*


ADVANCED NEXT STEP:
Create a FraudRules configuration table, move risk thresholds into data, and
write a stored procedure that evaluates a new transaction against active rules.
*/
