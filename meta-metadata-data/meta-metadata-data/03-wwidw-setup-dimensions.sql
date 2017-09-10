/*
SET NOEXEC OFF;
--*/ SET NOEXEC ON;

/*
 * file: 00-setup.sql
*/

USE WWIDW;
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = N'Dimension')
BEGIN
	EXEC ('CREATE SCHEMA Dimension AUTHORIZATION dbo;'); -- Dimension: Dimensions' tables
END;
GO

IF OBJECT_ID(N'Dimension.City', N'U') IS NOT NULL
BEGIN
	DROP TABLE Dimension.City;
END;
GO

SELECT TOP 0
	ACi.CityID,

	CONVERT(VARBINARY(20), HASHBYTES('MD5', CONCAT(
		ACi.CityID,
		''
	))) AS HistoricalHashKey,
	CONVERT(VARBINARY(20), HASHBYTES('MD5', CONCAT(
		ACi.CityName,
		ASP.StateProvinceName,
		ACo.CountryName,
		ACo.Region,
		ACo.Subregion,
		''
	))) AS ChangeHashKey,

    ACi.CityName,
    --ACi.StateProvinceID,
    --ASP.StateProvinceID,
    ASP.StateProvinceName,
    --ASP.CountryID,
    --ACo.CountryID,
    ACo.CountryName,
    ACo.Region,
    ACo.Subregion

INTO Dimension.City

FROM Landing_WWI.Application_Cities ACi
INNER JOIN Landing_WWI.Application_StateProvinces ASP ON ASP.StateProvinceID = ACi.StateProvinceID
INNER JOIN Landing_WWI.Application_Countries ACo ON ACo.CountryID = ASP.CountryID;
GO

ALTER TABLE Dimension.City ADD CONSTRAINT PK_Dimension_City PRIMARY KEY CLUSTERED (CityID);
GO

IF OBJECT_ID(N'Dimension.Customer', N'U') IS NOT NULL
BEGIN
	DROP TABLE Dimension.Customer;
END;
GO

SELECT TOP 0
	SC.CustomerID,

	CONVERT(VARBINARY(20), HASHBYTES('MD5', CONCAT(
		SC.CustomerID,
		''
	))) AS HistoricalHashKey,
	CONVERT(VARBINARY(20), HASHBYTES('MD5', CONCAT(
		SC.CustomerName,
		SC.DeliveryCityID,
		''
	))) AS ChangeHashKey,

    SC.CustomerName,
    SC.DeliveryCityID

INTO Dimension.Customer

FROM Landing_WWI.Sales_Customers SC
INNER JOIN Landing_WWI.Application_Cities ACi ON ACi.CityID = SC.DeliveryCityID;
GO

ALTER TABLE Dimension.Customer ADD CONSTRAINT PK_Dimension_Customer PRIMARY KEY CLUSTERED (CustomerID);
GO

ALTER TABLE Dimension.Customer ADD CONSTRAINT FK_Dimension_Customer_DeliveryCityID FOREIGN KEY (DeliveryCityID) REFERENCES Dimension.City (CityID);
GO
