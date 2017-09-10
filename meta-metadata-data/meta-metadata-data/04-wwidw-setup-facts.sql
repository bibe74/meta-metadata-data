/*
SET NOEXEC OFF;
--*/ SET NOEXEC ON;

/*
 * file: 00-setup.sql
*/

USE WWIDW;
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = N'Fact')
BEGIN
	EXEC ('CREATE SCHEMA Fact AUTHORIZATION dbo;'); -- Fact: Fact tables
END;
GO

IF OBJECT_ID(N'Fact.Order', N'U') IS NOT NULL
BEGIN
	DROP TABLE Fact.[Order];
END;
GO

SELECT TOP 0
	SOL.OrderLineID,

	CONVERT(VARBINARY(20), HASHBYTES('MD5', CONCAT(
		SOL.OrderLineID,
		''
	))) AS HistoricalHashKey,
	CONVERT(VARBINARY(20), HASHBYTES('MD5', CONCAT(
		SO.CustomerID,
		SC.DeliveryCityID,
		SO.OrderDate,
		SOL.Quantity,
		SOL.Quantity,
		SOL.UnitPrice,
		''
	))) AS ChangeHashKey,

    --SOL.OrderID,
    --SO.OrderID,
    SO.CustomerID,
    --SC.CustomerID,
    --SC.CustomerName,
    SC.DeliveryCityID,
	SO.OrderDate,
    
	SOL.Quantity,
    SOL.Quantity * SOL.UnitPrice AS Amount

INTO Fact.[Order]

FROM Landing_WWI.Sales_OrderLines SOL
INNER JOIN Landing_WWI.Sales_Orders SO ON SO.OrderID = SOL.OrderID
INNER JOIN Landing_WWI.Sales_Customers SC ON SC.CustomerID = SO.CustomerID;
GO

ALTER TABLE Fact.[Order] ADD CONSTRAINT PK_Fact_Order PRIMARY KEY CLUSTERED (OrderLineID);
GO

ALTER TABLE Fact.[Order] ADD CONSTRAINT FK_Fact_Order_CustomerID FOREIGN KEY (CustomerID) REFERENCES Dimension.Customer (CustomerID);
GO

ALTER TABLE Fact.[Order] ADD CONSTRAINT FK_Fact_Order_DeliveryCityID FOREIGN KEY (DeliveryCityID) REFERENCES Dimension.City (CityID);
GO
