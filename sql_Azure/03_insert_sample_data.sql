
USE TechStopDB;
GO
SET NOCOUNT ON;

-----------------------------
-- Suppliers sample data
-----------------------------

INSERT INTO dbo.Supplier(SupplierName, Phone, Email, URL)
VALUES
('Acme Tech Supply', '555-555-1000', 'sales@acmetech.com', 'https://acmetech.com'),
('Global Gizmos', '555-555-2000', 'sales@globalgizmos.com', 'https://globalgizmos.com'),
('Eastwind Computer Parts', '555-555-3000', 'sales@eastwindcomputerparts.com', 'https://eastwindcomputerparts.com');

-----------------------------------------------------------------
-- Products Sample Data (Uses SupplierName to lookup SupplierId)
-----------------------------------------------------------------
INSERT INTO dbo.Product(ProductName, Description, Price, QuantityInStock, SupplierId)
VALUES
('USB-C Cable 1m', 'Durable braided cable', 9.99, 200,
	(SELECT Id FROM dbo.Supplier WHERE SupplierName='Acme Tech Supply')),
('Laptop Stand',   'Aluminum, adjustable height', 39.99, 50,
    (SELECT Id FROM dbo.Supplier WHERE SupplierName='Acme Tech Supply')),
('Stylus Pen',   'Rechargable | Compatible with Kindle', 45.99, 120,
    (SELECT Id FROM dbo.Supplier WHERE SupplierName='Acme Tech Supply')),
('Wireless Mouse', '2.4GHz, ergonomic', 24.99, 80,
    (SELECT Id FROM dbo.Supplier WHERE SupplierName='Global Gizmos')),
('27" Monitor',   '1080p IPS display', 179.99, 35,
    (SELECT Id FROM dbo.Supplier WHERE SupplierName='Global Gizmos')),
('Full Keyboard',   'Bluetooth wireless', 50.00, 87,
    (SELECT Id FROM dbo.Supplier WHERE SupplierName='Global Gizmos')),
('Mechanical Keyboard', 'Blue switches', 89.99, 25,
    (SELECT Id FROM dbo.Supplier WHERE SupplierName='Eastwind Computer Parts')),
('Bluetooth Gaming Headphones', '4320 USB-C with charge stand Headset', 139.99, 72,
	(SELECT Id FROM dbo.Supplier WHERE SupplierName='Eastwind Computer Parts')),
('Waterproof Bluetooth Speaker', 'Wireless Bluetooth speaker with USB-C charging cable', 180.00, 57,
	(SELECT Id FROM dbo.Supplier WHERE SupplierName='Eastwind Computer Parts'));

------------------------
-- Customers Sample Data
------------------------
INSERT INTO dbo.Customer(FirstName, LastName, Phone, Email, CreatedAt, UpdatedAt, IsActive)
VALUES
('John', 'Doe', '123-555-0000', 'john.doe@example.com', SYSDATETIME(), NULL, 1),
('Jane', 'Poe', '123-555-0001', 'jane.poe@example.com', SYSDATETIME(), NULL, 1),
('Dorothy', 'Gale', '123-555-0002', 'dorothy.gale@example.com', SYSDATETIME(), NULL, 1),
('Sam', 'Smith', '123-555-0003', 'sam.smith@example.com', SYSDATETIME(), NULL, 1),
('Charlie', 'Charleston', '123-555-0004', 'charlie.charelston@example.com', SYSDATETIME(), NULL, 1);

---------------
-- Employees Sample Data
---------------
INSERT INTO dbo.Employee(FirstName, LastName, Phone, Email, CreatedAt, UpdatedAt, IsActive)
VALUES
('Bobby', 'Smith', '555-123-1243', 'bobby.smith@TechStop.com', SYSDATETIME(), NULL, 1),
('James', 'Peach', '555-123-1234', 'james.peach@TechStop.com', SYSDATETIME(), NULL, 1),
('Alice', 'Wonderland', '555-123-1243', 'alice.wonderland@TechStop.com', SYSDATETIME(), NULL, 1),
('Harry', 'Potter', '555-123-0012', 'harry.potter@TechStop.com', SYSDATETIME(), NULL, 1),
('Carl', 'Jones', '123-123-1243', 'carl.jones@TechStop.com', SYSDATETIME(), NULL, 1);

-------------------------------
-- Orders and Items Sample Data
-------------------------------
Declare @TaxRate DECIMAL(5,4) = 0.0825; -- 8.25% tax rate

-- Helpers (by name so you don't need to look up IDs)
--Customer Helpers
DECLARE @JohnId INT=(SELECT Id FROM dbo.Customer WHERE Email='john.doe@example.com');
DECLARE @JaneId INT = (SELECT Id FROM dbo.Customer WHERE Email='jane.poe@example.com');
DECLARE @DorothyId INT = (SELECT Id FROM dbo.Customer WHERE Email='dorothy.gale@example.com');
DECLARE @SamId INT = (SELECT Id FROM dbo.Customer WHERE Email='sam.smith@example.com');
DECLARE @CharlieId INT = (SELECT Id FROM dbo.Customer WHERE Email='charlie.charelston@example.com');

--Employee Helpers
DECLARE @BobbyId INT=(SELECT Id FROM dbo.Employee WHERE Email='bobby.smith@TechStop.com');
DECLARE @JamesId INT=(SELECT Id FROM dbo.Employee WHERE Email='james.peach@TechStop.com');
DECLARE @AliceId INT=(SELECT Id FROM dbo.Employee WHERE Email='alice.wonderland@TechStop.com');
DECLARE @HarryId INT=(SELECT Id FROM dbo.Employee WHERE Email='harry.potter@TechStop.com');
DECLARE @CarlId INT=(SELECT Id FROM dbo.Employee WHERE Email='carl.jones@TechStop.com');

--Product Helpers
DECLARE @CableId INT = (SELECT Id FROM dbo.Product WHERE ProductName = 'USB-C Cable 1m');
DECLARE @LaptopStandId INT = (SELECT Id FROM dbo.Product WHERE ProductName = 'Laptop Stand');
DECLARE @StylusPenId INT = (SELECT Id FROM dbo.Product WHERE ProductName = 'Stylus Pen');
DECLARE @WirelessMouseId INT = (SELECT Id FROM dbo.Product WHERE ProductName = 'Wireless Mouse');
DECLARE @MonitorId INT = (SELECT Id FROM dbo.Product WHERE ProductName = '27" Monitor');
DECLARE @FullKeyboardId INT = (SELECT Id FROM dbo.Product WHERE ProductName = 'Full Keyboard');
DECLARE @MechanicalKeyboardId INT = (SELECT Id FROM dbo.Product WHERE ProductName = 'Mechanical Keyboard');
DECLARE @HeadphonesId INT = (SELECT Id FROM dbo.Product WHERE ProductName = 'Bluetooth Gaming Headphones');
DECLARE @SpeakerId INT = (SELECT Id FROM dbo.Product WHERE ProductName = 'Waterproof Bluetooth Speaker');

---------------------------------------------------------------------
-- Order 1 (John Doe) 
---------------------------------------------------------------------
INSERT INTO dbo.CustomerOrder (CustomerId, EmployeeId, OrderDate, Status)
VALUES (@JohnId, @BobbyId, DATEADD(DAY,-2,SYSDATETIME()),'Completed')      

DECLARE @Order1 INT = SCOPE_IDENTITY();            

INSERT INTO dbo.OrderItem (OrderId, ProductId, Quantity, UnitPrice, Discount)
VALUES
(@Order1, @CableId, 2, (SELECT Price FROM dbo.Product WHERE Id=@CableId), 0.00),
(@Order1, @FullKeyboardId, 2, (SELECT Price FROM DBO.Product WHERE Id=@FullKeyboardId), 5.00);

-- Recalc total for Order 1
UPDATE o
SET Subtotal = x.Subtotal,
	Tax = ROUND(@TaxRate * x.Subtotal, 2),
	Total    = x.Subtotal - o.DiscountAmount + ROUND(@TaxRate * x.Subtotal, 2)
FROM dbo.CustomerOrder AS o
JOIN(
	SELECT oi.OrderId,
		SUM( (oi.UnitPrice - ISNULL(oi.Discount,0)) * oi.Quantity ) AS Subtotal
	FROM dbo.OrderItem oi
	WHERE oi.OrderId = @Order1
	GROUP BY oi.OrderId
) AS x ON x.OrderId = o.Id;


---------------------------------------------------------------------
-- Order 2 (Jane Poe) 
---------------------------------------------------------------------
INSERT INTO dbo.CustomerOrder (CustomerId, EmployeeId, OrderDate, Status, DiscountAmount)
VALUES (@JaneId, @JamesId, DATEADD(DAY,-1,SYSDATETIME()), 'Completed',10.00); -- Order Level Discount

DECLARE @Order2 INT = SCOPE_IDENTITY();

INSERT INTO dbo.OrderItem (OrderId, ProductId, Quantity, UnitPrice, Discount)
VALUES
(@Order2, @LaptopStandId, 5, (SELECT Price FROM dbo.Product WHERE Id=@LaptopStandId), 15.00),
(@Order2, @StylusPenId, 20, (SELECT Price FROM dbo.Product WHERE Id=@StylusPenId), 0.00);

-- Recalc totals for Order 2
UPDATE o
SET  Subtotal = x.Subtotal,
     Tax      = ROUND(@TaxRate * x.Subtotal, 2),
     Total    = x.Subtotal - o.DiscountAmount + ROUND(@TaxRate * x.Subtotal, 2)
FROM dbo.CustomerOrder AS o
JOIN (
    SELECT oi.OrderId,
           SUM( (oi.UnitPrice - ISNULL(oi.Discount,0)) * oi.Quantity ) AS Subtotal
    FROM dbo.OrderItem AS oi
    WHERE oi.OrderId = @Order2      
    GROUP BY oi.OrderId
) AS x ON x.OrderId = o.Id;

---------------------------------------------------------------------
-- Order 3 (Dorothy Gale) 
---------------------------------------------------------------------
INSERT INTO dbo.CustomerOrder (CustomerId, EmployeeId, OrderDate, Status)
VALUES (@DorothyId, @AliceId, DATEADD(DAY, -1, SYSDATETIME()), 'Completed');

DECLARE @Order3 INT = SCOPE_IDENTITY();

INSERT INTO dbo.OrderItem (OrderId, ProductId, Quantity, UnitPrice, Discount)
VALUES
(@Order3, @WirelessMouseId, 25, (SELECT Price FROM dbo.Product WHERE Id=@WirelessMouseId), 5.00),
(@Order3, @MonitorId, 10, (SELECT Price FROM dbo.Product WHERE Id=@MonitorId), 20.00);

--recalc total for Order 3
UPDATE o
SET Subtotal = x.Subtotal,
	Tax = ROUND(@TaxRate * x.Subtotal, 2),
	Total = x.Subtotal - o.DiscountAmount + ROUND(@TaxRate * x.Subtotal, 2)
FROM dbo.CustomerOrder AS o
JOIN (
    SELECT oi.OrderId,
           SUM( (oi.UnitPrice - ISNULL(oi.Discount,0)) * oi.Quantity ) AS Subtotal
    FROM dbo.OrderItem oi
    WHERE oi.OrderId = @Order3
    GROUP BY oi.OrderId
) AS x ON x.OrderId = o.Id;

---------------------------------------------------------------------
-- Order 4 (Sam Smith) 
---------------------------------------------------------------------
INSERT INTO dbo.CustomerOrder (CustomerId, EmployeeId, OrderDate, Status)
VALUES (@SamId, @HarryId, DATEADD(DAY, -45, SYSDATETIME()), 'Completed');

DECLARE @Order4 INT = SCOPE_IDENTITY();

INSERT INTO dbo.OrderItem (OrderId, ProductId, Quantity, UnitPrice, Discount)
VALUES
(@Order4, @FullKeyboardId, 25, (SELECT Price FROM dbo.Product WHERE Id=@FullKeyboardId), 10.00),
(@Order4, @MechanicalKeyboardId, 75, (SELECT Price FROM dbo.Product WHERE Id=@MechanicalKeyboardId), 25.00),
(@Order4, @CableId, 100, (SELECT Price FROM dbo.Product WHERE Id=@CableId), 10.00),
(@Order4, @LaptopStandId, 25, (SELECT Price FROM dbo.Product WHERE Id=@LaptopStandId), 5.00);

-- Recalc totals for Order 4
UPDATE o
SET Subtotal = x.Subtotal,
	Tax = ROUND(@TaxRate * x.Subtotal, 2),
	Total = x.Subtotal - o.DiscountAmount + ROUND(@TaxRate * x.Subtotal, 2)
FROM dbo.CustomerOrder AS o
JOIN (
    SELECT oi.OrderId,
           SUM( (oi.UnitPrice - ISNULL(oi.Discount,0)) * oi.Quantity ) AS Subtotal
    FROM dbo.OrderItem oi
    WHERE oi.OrderId = @Order4
    GROUP BY oi.OrderId
) AS x ON x.OrderId = o.Id;

---------------------------------------------------------------------
-- Order 5 (Charlie Charleston) 
---------------------------------------------------------------------
INSERT INTO dbo.CustomerOrder (CustomerId, EmployeeId, OrderDate, Status)
VALUES (@CharlieId, @CarlId, DATEADD(DAY, -72, SYSDATETIME()), 'Completed');

DECLARE @Order5 INT = SCOPE_IDENTITY();

INSERT INTO dbo.OrderItem (OrderId, ProductId, Quantity, UnitPrice, Discount)
VALUES
(@Order5, @SpeakerId, 10, (SELECT Price FROM dbo.Product WHERE Id=@SpeakerId), 0.00),
(@Order5, @HeadphonesId, 25, (SELECT Price FROM dbo.Product WHERE Id=@HeadphonesId), 5.00),
(@Order5, @CableId, 25, (SELECT Price FROM dbo.Product WHERE Id=@CableId), 3.00);

--Recalculate totals on Order 5
UPDATE o 
SET Subtotal = x.Subtotal,
	Tax = ROUND(@TaxRate * x.Subtotal, 2),
	Total = x.Subtotal - o.DiscountAmount + ROUND(@TaxRate * x.Subtotal, 2)
FROM dbo.CustomerOrder AS o
JOIN(
	SELECT oi.OrderId,
		SUM( (oi.UnitPrice - ISNULL(oi.Discount,0)) * oi.Quantity ) AS Subtotal
	FROM dbo.OrderItem oi
	WHERE oi.OrderId = @Order5
	GROUP BY oi.OrderId
) AS x ON x.OrderId = o.Id;

