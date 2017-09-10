/*
SET NOEXEC OFF;
--*/ SET NOEXEC ON;

/*
 * file: 02-wwidw-setup-landing_wwi.sql
*/

USE master;
GO

/* If the database exists, drop it */
IF DB_ID('WWIDW') IS NOT NULL
BEGIN
    ALTER DATABASE WWIDW SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE WWIDW;
END
GO

/* If the database doesn't exist (it shouldn't!), create it */
IF DB_ID('WWIDW') IS NULL
BEGIN
    CREATE DATABASE WWIDW;
END
GO

USE WWIDW;
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = N'Landing_WWI')
BEGIN
	EXEC ('CREATE SCHEMA Landing_WWI AUTHORIZATION dbo;'); -- Landing_WWI: landing area for WideWorldImporters' tables
END;
GO

IF OBJECT_ID(N'Landing_WWI.Sales_OrderLines', N'U') IS NOT NULL
BEGIN
	DROP TABLE Landing_WWI.Sales_OrderLines;
END;
GO

SELECT TOP 0
	OrderLineID,
	OrderID,
	Quantity,
	UnitPrice

INTO Landing_WWI.Sales_OrderLines

FROM WideWorldImporters.Sales.OrderLines;
GO

ALTER TABLE Landing_WWI.Sales_OrderLines ADD CONSTRAINT PK_Landing_WWI_Sales_OrderLines PRIMARY KEY CLUSTERED (OrderLineID);
GO

IF OBJECT_ID(N'Landing_WWI.Sales_Orders', N'U') IS NOT NULL
BEGIN
	DROP TABLE Landing_WWI.Sales_Orders;
END;
GO

SELECT TOP 0
	OrderID,
	CustomerID,
	OrderDate

INTO Landing_WWI.Sales_Orders

FROM WideWorldImporters.Sales.Orders;
GO

ALTER TABLE Landing_WWI.Sales_Orders ADD CONSTRAINT PK_Landing_WWI_Sales_Orders PRIMARY KEY CLUSTERED (OrderID);
GO

IF OBJECT_ID(N'Landing_WWI.Sales_Customers', N'U') IS NOT NULL
BEGIN
	DROP TABLE Landing_WWI.Sales_Customers;
END;
GO

SELECT TOP 0
	CustomerID,
	CustomerName,
	DeliveryCityID

INTO Landing_WWI.Sales_Customers

FROM WideWorldImporters.Sales.Customers;
GO

ALTER TABLE Landing_WWI.Sales_Customers ADD CONSTRAINT PK_Landing_WWI_Sales_Customers PRIMARY KEY CLUSTERED (CustomerID);
GO

IF OBJECT_ID(N'Landing_WWI.Application_Cities', N'U') IS NOT NULL
BEGIN
	DROP TABLE Landing_WWI.Application_Cities;
END;
GO

SELECT TOP 0
	CityID,
	CityName,
	StateProvinceID

INTO Landing_WWI.Application_Cities

FROM WideWorldImporters.Application.Cities;
GO

ALTER TABLE Landing_WWI.Application_Cities ADD CONSTRAINT PK_Landing_WWI_Application_Cities PRIMARY KEY CLUSTERED (CityID);
GO

IF OBJECT_ID(N'Landing_WWI.Application_StateProvinces', N'U') IS NOT NULL
BEGIN
	DROP TABLE Landing_WWI.Application_StateProvinces;
END;
GO

SELECT TOP 0
	StateProvinceID,
	StateProvinceName,
	CountryID

INTO Landing_WWI.Application_StateProvinces

FROM WideWorldImporters.Application.StateProvinces;
GO

ALTER TABLE Landing_WWI.Application_StateProvinces ADD CONSTRAINT PK_Landing_WWI_Application_StateProvinces PRIMARY KEY CLUSTERED (StateProvinceID);
GO

IF OBJECT_ID(N'Landing_WWI.Application_Countries', N'U') IS NOT NULL
BEGIN
	DROP TABLE Landing_WWI.Application_Countries;
END;
GO

SELECT TOP 0
	CountryID,
	CountryName,
    Region,
    Subregion

INTO Landing_WWI.Application_Countries

FROM WideWorldImporters.Application.Countries;
GO

ALTER TABLE Landing_WWI.Application_Countries ADD CONSTRAINT PK_Landing_WWI_Application_Countries PRIMARY KEY CLUSTERED (CountryID);
GO
