USE shreya06DW;

---------------------------------Creation of Tables------------------------------------

create table dbo.DimStore
(
StoreKey int NOT NULL IDENTITY(1,1) PRIMARY KEY,
StoreID int,
StoreNumber int,
StoreManager nvarchar(255),
AddressKey int FOREIGN KEY REFERENCES dbo.DimAddress(AddressKey),
PhoneNumber nvarchar(20),
CreatedDate datetime,
CreatedBy nvarchar(255),
ModifiedDate datetime,
ModifiedBy nvarchar(255)
);

create table dbo.DimProduct
(
ProductKey int NOT NULL IDENTITY(1,1) PRIMARY KEY,
ProductID int,
Product nvarchar(255),
Color nvarchar(255),
Style nvarchar(255),
Weight decimal(10,2),
ProductTypeID int,
ProductType int,
ProductCategoryID int,
ProductCategory nvarchar(255),
Cost decimal(10,2),
Price decimal(10,2),
WholesalePrice decimal(10,2),
CreatedDate datetime,
CreatedBy nvarchar(255),
ModifiedDate datetime,
ModifiedBy nvarchar(255)
);

create table dbo.DimChannel
(
ChannelKey int NOT NULL IDENTITY(1,1) PRIMARY KEY,
ChannelID int,
Channel nvarchar(255),
ChannelCategoryID int,
ChannelCategory nvarchar(255),
CreatedDate datetime,
CreatedBy nvarchar(255),
ModifiedDate datetime,
ModifiedBy nvarchar(255)
);

Create table dbo.DimAddress
(
AddressKey int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Address nvarchar(255),
City nvarchar(255),
StateProvince nvarchar(255),
Country nvarchar(255),
PostalCode nvarchar(255),
CreatedDate datetime NOT NULL,
CreatedBy nvarchar(255) NOT NULL,
ModifiedDate datetime,
ModifiedBy nvarchar(255)
);

create table dbo.DimCustomer
(
CustomerKey int NOT NULL IDENTITY(1,1) PRIMARY KEY,
CustomerID int,
FirstName nvarchar(255),
LastName nvarchar(255),
EmailAddress nvarchar(255),
AddressKey int FOREIGN KEY REFERENCES dbo.DimAddress(AddressKey),
PhoneNumber nvarchar(10),
Gender nvarchar(10),
CreatedDate datetime,
CreatedBy nvarchar(255),
ModifiedDate datetime,
ModifiedBy nvarchar(255)
);

create table dbo.DimReseller
(
ResellerKey int NOT NULL IDENTITY(1,1) PRIMARY KEY,
ResellerID nvarchar(50),
ResellerName nvarchar(255),
AddressKey int FOREIGN KEY REFERENCES dbo.DimAddress(AddressKey),
Contact nvarchar(255),
EmailAddress nvarchar(255),
PhoneNumber nvarchar(20),
CreatedDate datetime,
CreatedBy nvarchar(255),
ModifiedDate datetime,
ModifiedBy nvarchar(255)
);

create table dbo.DimDate
(
DateKey int NOT NULL IDENTITY(1,1) PRIMARY KEY,
ActualDate date,
Day int,
Week int,
Month int,
Year int,
CreatedDate datetime,
CreatedBy nvarchar(255),
ModifiedDate datetime,
ModifiedBy nvarchar(255)
);

create table dbo.FactProdTarget
(
ProductKey int FOREIGN KEY REFERENCES dbo.DimProduct(ProductKey),
DateKey int FOREIGN KEY REFERENCES dbo.DimDate(DateKey),
DailyProductTarget decimal(10,2)
);

create table dbo.FactChannelTarget
(
ChannelKey int FOREIGN KEY REFERENCES dbo.DimChannel(ChannelKey),
ResellerKey int FOREIGN KEY REFERENCES dbo.DimReseller(ResellerKey),
DateKey int FOREIGN KEY REFERENCES dbo.DimDate(DateKey),
AddressKey int FOREIGN KEY REFERENCES dbo.DimAddress(AddressKey),
DailyChannelTarget decimal(10,2)
);

create table dbo.FactSales
(
ProductKey int FOREIGN KEY REFERENCES dbo.DimProduct(ProductKey),
DateKey int FOREIGN KEY REFERENCES dbo.DimDate(DateKey),
CustomerKey int FOREIGN KEY REFERENCES dbo.DimCustomer(CustomerKey),
StoreKey int FOREIGN KEY REFERENCES dbo.DimStore(StoreKey),
ResellerKey int FOREIGN KEY REFERENCES dbo.DimReseller(ResellerKey),
ChannelKey int FOREIGN KEY REFERENCES dbo.DimChannel(ChannelKey),
AddressKey int FOREIGN KEY REFERENCES dbo.DimAddress(AddressKey),
SalesQuantity int,
SalesAmount decimal(10,2),
ProfitPerProduct decimal(10,2),
SalesDetailID int,
SalesHeaderID int
);

---------------------------------Insertion of Data------------------------------------

---DimAddress---

alter table dbo.FactSales nocheck constraint all
alter table dbo.DimCustomer nocheck constraint all
alter table dbo.DimStore nocheck constraint all
alter table dbo.FactChannelTarget nocheck constraint all
alter table dbo.DimReseller nocheck constraint all
delete from dbo.DimAddress
alter table dbo.DimReseller check constraint all
alter table dbo.FactChannelTarget check constraint all
alter table dbo.DimStore check constraint all
alter table dbo.DimCustomer check constraint all
alter table dbo.FactSales check constraint all
DBCC CHECKIDENT ('dbo.DimAddress', RESEED, 0);

SET IDENTITY_INSERT dbo.DimAddress ON;
INSERT INTO dbo.DimAddress
(AddressKey, Address, City, StateProvince, Country, PostalCode, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy)
VALUES
(-1, 0, 0, 0, 0, 0, 0, 0, 0, 0)
SET IDENTITY_INSERT dbo.DimAddress OFF;

insert into dbo.DimAddress
select Address, City, StateProvince, Country, PostalCode, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy 
from dbo.StageReseller;
insert into dbo.DimAddress
select Address, City, StateProvince, Country, PostalCode, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy 
from dbo.StageCustomer;
insert into dbo.DimAddress
select Address, City, StateProvince, Country, PostalCode, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy 
from dbo.StageStore;


---DimChannel---

alter table dbo.FactSales nocheck constraint all
alter table dbo.FactChannelTarget nocheck constraint all
delete from dbo.DimChannel
alter table dbo.FactChannelTarget check constraint all
alter table dbo.FactSales check constraint all
DBCC CHECKIDENT ('dbo.DimChannel', RESEED, 0);

SET IDENTITY_INSERT dbo.DimChannel ON;
INSERT INTO dbo.DimChannel
(ChannelKey, ChannelID, Channel, ChannelCategoryID, ChannelCategory, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy)
VALUES
(-1, 0, 0, 0, 0, 0, 0, 0, 0)
SET IDENTITY_INSERT dbo.DimChannel OFF;

INSERT INTO dbo.DimChannel
SELECT sc.ChannelID, sc.Channel, scc.ChannelCategoryID, scc.ChannelCategory, sc.CreatedDate, sc.CreatedBy, sc.ModifiedDate, sc.ModifiedBy from dbo.StageChannelCategory scc join dbo.StageChannel sc on scc.ChannelCategoryID = sc.ChannelCategoryID;

update dbo.DimChannel 
set
Channel = N'Online' 
where Channel = 'On-line';


---DimProduct---

alter table dbo.FactSales nocheck constraint all
alter table dbo.FactProdTarget nocheck constraint all
delete from dbo.DimProduct
alter table dbo.FactProdTarget check constraint all
alter table dbo.FactSales check constraint all
DBCC CHECKIDENT ('dbo.DimProduct', RESEED, 0);

SET IDENTITY_INSERT dbo.DimProduct ON;
INSERT INTO dbo.DimProduct
(ProductKey, ProductID, Product, Color, Style, ProdWeight, ProductTypeID, ProductType, ProductCategoryID, ProductCategory, Cost, Price, WholesalePrice, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy)
VALUES
(-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
SET IDENTITY_INSERT dbo.DimProduct OFF;

INSERT INTO dbo.DimProduct
SELECT sp.ProductID, sp.Product, sp.Color, sp.Style, sp.Weight, sp.ProductTypeID, spt.ProductType, spt.ProductCategoryID, spc.ProductCategory, sp.Cost, sp.Price, sp.WholesalePrice, sp.CreatedDate, sp.CreatedBy, sp.ModifiedDate, sp.ModifiedBy 
from dbo.StageProduct sp join dbo.StageProductType spt on sp.ProductTypeID = spt.ProductTypeID join dbo.StageProductCategory spc on spt.ProductCategoryID = spc.ProductCategoryID;


--DimCustomer---

alter table dbo.FactSales nocheck constraint all
DELETE FROM dbo.DimCustomer
alter table dbo.FactSales check constraint all
DBCC CHECKIDENT ('dbo.DimCustomer', RESEED, 0);

SET IDENTITY_INSERT dbo.DimCustomer ON;
INSERT INTO dbo.DimCustomer
(CustomerKey, CustomerID, FirstName, LastName, EmailAddress, PhoneNumber, Gender, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy, AddressKey)
VALUES
(-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1)
SET IDENTITY_INSERT dbo.DimCustomer OFF;

INSERT INTO dbo.DimCustomer(CustomerID, FirstName, LastName, EmailAddress, PhoneNumber, Gender, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy, AddressKey)
SELECT sc.CustomerID, sc.FirstName, sc.LastName, sc.EmailAddress, sc.PhoneNumber, sc.Gender, sc.CreatedDate, sc.CreatedBy, sc.ModifiedDate, sc.ModifiedBy, da.AddressKey 
from dbo.StageCustomer sc join dbo.DimAddress da on da.Address = sc.Address;


---DimStore---

alter table dbo.FactChannelTarget nocheck constraint all
alter table dbo.FactSales nocheck constraint all
DELETE FROM dbo.DimStore;
alter table dbo.FactSales check constraint all
alter table dbo.FactChannelTarget check constraint all
DBCC CHECKIDENT ('dbo.DimStore', RESEED, 0);

SET IDENTITY_INSERT dbo.DimStore ON;
INSERT INTO dbo.DimStore
(StoreKey, StoreID, StoreNumber, StoreManager, AddressKey, PhoneNumber, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy)
VALUES
(-1, 0, 0, 0, -1, 0, 0, 0, 0, 0)
SET IDENTITY_INSERT dbo.DimStore OFF;

insert into dbo.DimStore (StoreID, StoreNumber, StoreManager, AddressKey, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy)
select ss.StoreID, 'Store' + ' ' + 'Number' + ' ' +cast(ss.StoreNumber as nvarchar), ss.StoreManager, da.AddressKey, ss.CreatedDate, ss.CreatedBy, ss.ModifiedDate, ss.ModifiedBy
from dbo.StageStore ss join dbo.DimAddress da on da.Address = ss.Address;


---DimReseller---

alter table dbo.FactSales nocheck constraint all
alter table dbo.FactChannelTarget nocheck constraint all
delete from dbo.DimReseller
alter table dbo.FactChannelTarget check constraint all
alter table dbo.FactSales check constraint all
DBCC CHECKIDENT ('dbo.DimReseller', RESEED, 0);

SET IDENTITY_INSERT dbo.DimReseller ON;
INSERT INTO dbo.DimReseller
(ResellerKey, ResellerID, ResellerName, AddressKey, Contact, EmailAddress, PhoneNumber, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy)
VALUES
(-1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0)
SET IDENTITY_INSERT dbo.DimReseller OFF;

insert into dbo.DimReseller (ResellerID, ResellerName, AddressKey, Contact, EmailAddress, PhoneNumber, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy)
select sr.ResellerID, sr.ResellerName, da.AddressKey, sr.Contact, sr.EmailAddress, sr.PhoneNumber, sr.CreatedDate, sr.CreatedBy, sr.ModifiedDate, sr.ModifiedBy
from dbo.StageReseller sr join dbo.DimAddress da on sr.Address = da.Address;


---Dimdate---

alter table dbo.FactSales nocheck constraint all
alter table dbo.FactChannelTarget nocheck constraint all
alter table dbo.FactProdTarget nocheck constraint all
delete from dbo.DimDate
alter table dbo.FactProdTarget check constraint all
alter table dbo.FactChannelTarget check constraint all
alter table dbo.FactSales check constraint all
DBCC CHECKIDENT ('dbo.DimDate', RESEED, 0);


DECLARE @StartDate  date = '20130101';

DECLARE @CutoffDate date = DATEADD(DAY, -1, DATEADD(YEAR, 2, @StartDate));

;WITH seq(n) AS 
(
  SELECT 0 UNION ALL SELECT n + 1 FROM seq
  WHERE n < DATEDIFF(DAY, @StartDate, @CutoffDate)
),
d(d) AS 
(
  SELECT DATEADD(DAY, n, @StartDate) FROM seq
),
src AS
(
  SELECT
    ActualDate         = CONVERT(date, d),
    Day          = DATEPART(DAY, d),
    Week         = DATEPART(WEEK, d),
    Month        = DATEPART(MONTH, d),
    Year         = DATEPART(YEAR, d)
  FROM d
)
INSERT INTO dbo.DimDate (ActualDate,Day,Week,Month,Year)
SELECT * FROM src
 ORDER BY ActualDate
  OPTION (MAXRECURSION 0);


---FactProdTarget---

DELETE FROM dbo.FactProdTarget;

insert into dbo.FactProdTarget
select dp.ProductKey, dd.DateKey, (spt.[SalesQuantityTarget ]/365)
from dbo.DimProduct dp join dbo.StageProductTarget spt on dp.ProductID=spt.ProductID join dbo.DimDate dd on dd.Year=spt.Year;


---FactChannelTarget---

DELETE FROM dbo.FactChannelTarget;

update dbo.StageChannelResellerTarget
set 
TargetName = N'Mississipi Distributors' 
where TargetName = 'Mississippi Distributors';

INSERT INTO dbo.FactChannelTarget (ChannelKey, StoreKey, ResellerKey, DateKey, DailyChannelTarget, AddressKey)
SELECT
ISNULL(dc.ChannelKey, -1), ISNULL(ds.StoreKey, -1), ISNULL(dr.ResellerKey, -1), dd.DateKey, (scrt.TargetSalesAmount/365), coalesce(NULL, ds.AddressKey, dr.AddressKey, -1)
FROM dbo.StageChannelResellerTarget scrt 
LEFT JOIN dbo.DimChannel dc
ON scrt.ChannelName = dc.Channel
LEFT JOIN dbo.DimDate dd 
ON dd.Year = scrt.Year
LEFT JOIN dbo.DimReseller dr
ON dr.ResellerName = scrt.TargetName
LEFT JOIN DimStore ds
ON ds.StoreNumber = scrt.TargetName;


---FactSales---

DELETE FROM dbo.FactSales;

update dbo.StageChannelResellerTarget
set 
TargetName = N'Mississipi Distributors' 
where TargetName = 'Mississippi Distributors';

INSERT INTO dbo.FactSales(ProductKey, StoreKey, ResellerKey, ChannelKey, CustomerKey, DateKey, SalesHeaderID, SalesDetailID, AddressKey, SalesAmount, SalesQuantity, ProfitPerProduct)
SELECT dp.ProductKey,
	ISNULL(ds.StoreKey,-1),
	ISNULL(dr.ResellerKey,-1),
	ISNULL(dchan.ChannelKey,-1),
	ISNULL(dc.CustomerKey, -1),
	ISNULL(dd.DateKey,-1),
	ssd.SalesHeaderID,
	ssd.SalesDetailID,
	coalesce(NULL, ds.AddressKey, dr.AddressKey, dc.AddressKey, -1),
	ssd.SalesAmount,
	ssd.SalesQuantity,
	(ssd.SalesAmount-(dp.Cost*ssd.SalesQuantity))
FROM dbo.StageSalesDetails ssd JOIN dbo.StageSalesheader ssh on ssd.SalesHeaderID = ssh.SalesHeaderID
	LEFT JOIN dbo.DimProduct dp
		ON ssd.ProductID = dp.ProductID
	LEFT JOIN dbo.DimStore ds
		ON ssh.StoreID = ds.StoreID
	LEFT JOIN dbo.DimReseller dr
		ON dr.ResellerID=convert(varchar(50),ssh.ResellerID)
	LEFT JOIN dbo.DimChannel dchan
		ON ssh.ChannelID = dchan.ChannelID
	LEFT JOIN dbo.DimDate dd
		ON ssh.Date = dd.ActualDate
	LEFT JOIN dbo.DimCustomer dc
		ON dc.CustomerID = convert(varchar(50), ssh.CustomerID);


----Creation of Views---

create view view_bonus2013 as
with 
a as (select COUNT(fs.ProductKey) as [Number of Products Sold], fs.ResellerKey, SUM(fs.ProfitPerProduct) as [Total Profit], dd.Year
from dbo.FactSales fs join dbo.DimProduct dp on fs.ProductKey=dp.ProductKey
join  dbo.DimDate dd on dd.DateKey=fs.DateKey
join dbo.DimChannel dc on dc.ChannelKey=fs.ChannelKey
where ResellerKey <> -1 and dp.ProductTypeID IN (7,8) and dc.Channel='Department Stores' and dd.Year=2013
group by fs.ResellerKey, dd.Year),
b as (select SUM(fs.ProfitPerProduct) as [Sum Profit]
from dbo.FactSales fs join dbo.DimProduct dp on fs.ProductKey=dp.ProductKey
join  dbo.DimDate dd on dd.DateKey=fs.DateKey
join dbo.DimChannel dc on dc.ChannelKey=fs.ChannelKey
where ResellerKey <> -1 and dp.ProductTypeID IN (7,8) and dc.Channel='Department Stores' and dd.Year=2013)
select a.ResellerKey, a.[Number of Products Sold], a.[Total Profit], a.[Total profit]/b.[Sum Profit] as Ratio, 
a.[Total Profit]/b.[Sum Profit]*100000 as [Bonus Given], a.Year
from a,b

create view view_bonus2014 as
with 
a as (select COUNT(fs.ProductKey) as [Number of Products Sold], fs.ResellerKey, SUM(fs.ProfitPerProduct) as [Total Profit], dd.Year
from dbo.FactSales fs join dbo.DimProduct dp on fs.ProductKey=dp.ProductKey
join  dbo.DimDate dd on dd.DateKey=fs.DateKey
join dbo.DimChannel dc on dc.ChannelKey=fs.ChannelKey
where ResellerKey <> -1 and dp.ProductTypeID IN (7,8) and dc.Channel='Department Stores' and dd.Year=2014
group by fs.ResellerKey, dd.Year),
b as (select SUM(fs.ProfitPerProduct) as [Sum Profit]
from dbo.FactSales fs join dbo.DimProduct dp on fs.ProductKey=dp.ProductKey
join  dbo.DimDate dd on dd.DateKey=fs.DateKey
join dbo.DimChannel dc on dc.ChannelKey=fs.ChannelKey
where ResellerKey <> -1 and dp.ProductTypeID IN (7,8) and dc.Channel='Department Stores' and dd.Year=2014)
select a.ResellerKey, a.[Number of Products Sold], a.[Total Profit], a.[Total profit]/b.[Sum Profit] as Ratio, 
a.[Total Profit]/b.[Sum Profit]*200000 as [Bonus Given], a.Year
from a,b








