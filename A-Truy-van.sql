--A. Câu Truy vấn
--1.Lập danh sách các Customer là Sales Manager của nước Mỹ (USA) hoặc là Owner 
--của Mexico. Danh sách gồm: Customer ID, Company Name, Contact Name, Address, 
--City, Contact Title.
SELECT	CustomerID, CompanyName, ContactName, Address, City, ContactTitle
FROM	Customers
WHERE	(ContactTitle = 'Sales Manager' AND Country = 'USA')
OR		(ContactTitle = 'Owner' AND Country = 'Mexico')

--2.Liệt kê danh sách khách hàng mà trong tên công ty có chứa một chữ “a” và một chữ “e”.
SELECT	* 
FROM	Customers
WHERE	CompanyName like '%a%e%'

--3.Lập danh sách các đơn hàng trong tháng 4/97 gồm các thông tin sau: Order ID, Order
--Date, Customer, Employee, Freight, New-Freight trong đó New-Freight =110%
--Freight.
SELECT	OrderID, OrderDate, CompanyName, FirstName + ' ' + LastName as EmployeeName, Freight, 'New-Freight' = 1.1*O.Freight
FROM	Customers C, Orders O, Employees E
WHERE	C.CustomerID = O.CustomerID
AND		O.EmployeeID = E.EmployeeID
AND		MONTH(O.OrderDate) = 4
AND		YEAR(O.OrderDate) = 1997

--4.Lập danh sách các Order có ngày đặt hàng các năm chẳn. Danh sách gồm: Order ID,
--Order Date, Customer, Employee trong đó Customer là Company Name của khách
--hàng, Employee lấy Last Name
SELECT	OrderID, OrderDate, CompanyName, LastName as EmployeeName
FROM	Customers C, Orders O, Employees E
WHERE	C.CustomerID = O.CustomerID
AND		O.EmployeeID = E.EmployeeID
AND		YEAR(O.OrderDate)%2=0
--4.1.Lập danh sách các khách hàng có ngày đặt hàng các năm chẳn. 
SELECT	DISTINCT C.*
FROM	Customers C, Orders O
WHERE	C.CustomerID = O.CustomerID
AND		YEAR(O.OrderDate)%2=0
--4.2.Lập danh sách các khách hàng mà mã KH đó là các mã KH có ngày đặt hàng các năm chẳn.
SELECT	*
FROM	Customers
WHERE	CustomerID in (SELECT DISTINCT CustomerID 
					   FROM Orders
					   WHERE YEAR(OrderDate)%2=0)

--5.Tính đơn giá trung bình cuả các sản phẩm có đơn giá lớn hơn 30, nhóm theo loại sản phẩm
SELECT	AVG(UnitPrice) as 'Average Price', CategoryID
FROM	Products
WHERE	UnitPrice > 30
GROUP BY CategoryID

--6.Lập danh sách các loại sản phẩm có đơn giá trung bình lớn hơn 30
SELECT	C.CategoryID, C.CategoryName, AVG(P.UnitPrice) as 'Average Price'
FROM	Products P, Categories C
WHERE	C.CategoryID = P.CategoryID
GROUP BY C.CategoryID, C.CategoryName
HAVING	AVG(P.UnitPrice) > 30

--7.Người ta muốn có danh sách chi tiết các hoá đơn (Order Details) trong năm 1997.
--Danh sách gồm các thông tin: Order ID, ProductName, Unit Price, Quantity,
--ThanhTien, Discount, TienGiamGia, TienPhaiTra trong đó: ThanhTien = UnitPrice*Quantity, 
--TienGiamGia = ThanhTien *Discount, TienPhaiTra = ThanhTien – TienGiamGia
SELECT	OD.OrderID, P.ProductName, OD.UnitPrice, OD.Quantity,
		'ThanhTien' = OD.UnitPrice * OD.Quantity,
		'TienGiamGia' = OD.UnitPrice * OD.Quantity * Discount,
		'TienPhaiTra' = OD.UnitPrice * OD.Quantity - OD.UnitPrice * OD.Quantity * Discount
FROM	[Order Details] OD, Products P, Orders O
WHERE	OD.ProductID = P.ProductID
AND		O.OrderID = OD.OrderID 
AND		YEAR(O.OrderDate) = 1997

--8.Thiết kế query tính doanh số của từng loại sản phẩm (Category) trong năm 1996. Danh
--sách gồm 2 cột: Category Name, Sales; trong đó SalesTotal = UnitPrice*Quantity*(1-Discount)
SELECT	C.CategoryName,
		ROUND (SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)),2) as [SalesTotal] -- Round: làm tròn doanh số đến 2 chữ số thập phân.
FROM	Categories C, Orders O, [Order Details] OD, Products P
WHERE	C.CategoryID = P.CategoryID
AND		P.ProductID = OD.ProductID
AND		OD.OrderID = O.OrderID
AND		YEAR(OrderDate) = 1996
GROUP BY C.CategoryName

--9.Thiết kế query tính tỉ lệ tiền cước mua hàng (Freight) của từng khách hàng trong năm
--1997. Danh sách gồm các cột: Company Name (của Customer), Freight, SalesTotal = UnitPrice * Quantity*(1-Discount), 
--Percent= Freight/SalesTotal.
SELECT	C.CompanyName,
		ROUND (SUM(O.Freight), 2) as [Freight],
		ROUND (SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)),2) as [SalesTotal],
		ROUND (SUM(O.Freight)/SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)),2) as [Percent]
FROM	Customers C, Orders O, [Order Details] OD
WHERE	C.CustomerID = O.CustomerID
AND		OD.OrderID = O.OrderID
AND		YEAR(OrderDate) = 1997
GROUP BY C.CompanyName

--10.Liệt kê danh sách nhân viên được thuê sau nhân viên Andrew.
SELECT	*
FROM	Employees
WHERE	HireDate > (SELECT HireDate
				    FROM Employees
				    WHERE FirstName = 'Andrew')
--11.Liệt kê các sản phẩm có cùng nhà cung cấp với sản phẩm Tofu.
SELECT	*
FROM	Products
WHERE	SupplierID in (SELECT SupplierID
					   FROM Products
					   WHERE ProductName ='Tofu')
--12.Cho biết sản phẩm được đặt nhiều nhất và đặt ít nhất trong ba tháng cuối năm 1997.
SELECT	*
FROM	Products
WHERE	ProductID IN (SELECT TOP 1 ProductID
					  FROM [Order Details] OD, Orders O
					  WHERE MONTH(OrderDate) in (10,11,12)
					  AND YEAR(OrderDate) = 1997
					  GROUP BY ProductID
					  ORDER BY SUM(Quantity) DESC)
UNION ALL
SELECT	*
FROM	Products
WHERE	ProductID IN (SELECT TOP 1 ProductID
					  FROM [Order Details] OD, Orders O
					  WHERE MONTH(OrderDate) in (10,11,12)
					  AND YEAR(OrderDate) = 1997
					  GROUP BY ProductID
					  ORDER BY SUM(Quantity) ASC)