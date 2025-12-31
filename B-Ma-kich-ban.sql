--B.Mã kịch bản
--13.Tạo danh sách các Product thuộc một loại nào đó khi nhập Category ID từ bàn phím.
--Danh sách gồm: Product Name, Unit Price, Supplier
CREATE PROC SP_GetProductbyCateID @CateID int
AS
BEGIN
	SELECT	P.ProductName, P.UnitPrice, S.CompanyName as SupplierName
	FROM	Products P, Suppliers S
	WHERE	P.SupplierID = S.SupplierID
	AND		P.CategoryID = @CateID
END
GO

EXEC SP_GetProductbyCateID @CateID = 2
DROP PROC SP_GetProductbyCateName

--Trường hợp nhập tên loại hàng thay vì ID
CREATE PROC SP_GetProductbyCateName @CateName NVARCHAR(100)
AS
BEGIN
	SELECT	P.ProductName, P.UnitPrice, S.CompanyName as SupplierName
	FROM	Products P, Suppliers S, Categories C
	WHERE	P.SupplierID = S.SupplierID
	AND		C.CategoryID = P.CategoryID 
	AND		C.CategoryName = @CateName	
END
GO

EXEC SP_GetProductbyCateName @CateName = 'Condiments'
DROP PROC SP_GetProductbyCateName

--14.Lập danh sách các Order có Order Date trong 1 khoảng thời gian nào đó. Tham số
--nhập: “From date:” và “To:”. Danh sách gồm: Order ID, Customer, ShipCountry,
--OrderDate
CREATE PROC SP_ListOrderbyDate @StartDate DATE, @EndDate DATE
AS
BEGIN
	SELECT	O.OrderID, C.CompanyName AS Customer, O.ShipCountry, O.OrderDate
	FROM	Orders O, Customers C
	WHERE	O.CustomerID = C.CustomerID
	AND		OrderDate BETWEEN @StartDate AND @EndDate
END
GO

SET DATEFORMAT DMY
EXEC SP_ListOrderbyDate @StartDate = '30/3/1997', @EndDate = '30/6/1997'
DROP PROC SP_ListOrderbyDate

--15.Viết khối lệnh hiển thị số đơn hàng từng nhân viên đã lập trong năm 1997, nếu số lượng
--đơn ít hơn 20 thì hiện thông báo “số lượng đơn quá ít”
SELECT	E.EmployeeID, 
		E.FirstName + ' ' + E.LastName AS EmployeeName,
		COUNT(O.OrderID) AS OrderCount,
		CASE
			WHEN COUNT(O.OrderID) < 20 THEN N'Số lượng đơn quá ít'
			ELSE ''
		END AS Note
FROM	Orders O, Employees E
WHERE	O.EmployeeID = E.EmployeeID
AND		YEAR(O.OrderDate) = 1997
GROUP BY E.EmployeeID, E.FirstName, E.LastName
ORDER BY 2 --Sắp xếp theo cột thứ 2 trong bảng

--Trường hợp nếu làm theo các năm động
CREATE PROC SP_CountOrderByEmployee @Year int
AS
BEGIN
	SELECT	E.EmployeeID, 
			E.FirstName + ' ' + E.LastName AS EmployeeName,
			COUNT(O.OrderID) AS OrderCount,
			CASE
				WHEN COUNT(O.OrderID) < 20 THEN N'Số lượng đơn quá ít'
				ELSE ''
			END AS Note
	FROM	Orders O, Employees E
	WHERE	O.EmployeeID = E.EmployeeID
	AND		YEAR(O.OrderDate) = @Year
	GROUP BY E.EmployeeID, E.FirstName, E.LastName
END
GO

EXEC SP_CountOrderByEmployee @Year = 1997
DROP PROC SP_CountOrderByEmployee

--16.Người ta muốn biết trong một ngày nào đó có số lượng đơn đặt hàng theo từng khách
--hàng cần phải hoàn tất hay không? (theo Required Date).
CREATE PROC SP_OrderRequiredDate @Date DATE
AS
BEGIN
	SELECT	C.CustomerID, C.CompanyName as CustomerName,
			COUNT(O.OrderID) AS CountOfOrderID
	FROM	Orders O, Customers C
	WHERE	O.CustomerID = C.CustomerID
	AND		O.RequiredDate = @Date
	GROUP BY C.CustomerID, C.CompanyName
END
GO

EXEC SP_OrderRequiredDate @Date = '9/4/1997'
DROP PROC SP_OrderRequiredDate

--17.Thông thường các khách hàng muốn biết thông tin về đơn hàng của họ đã đặt hàng
--vào một ngày nào đó. (Khách hàng sẽ báo tên công ty và ngày đặt hàng). Thông
--tin gồm tất cả các cột của table Order. Anh chị hãy thiết kế query để thực hiện điều
--này.
CREATE PROC SP_OrderByNameDate @Name NVARCHAR(40), @Date DATE
AS
BEGIN
	SELECT	* 
	FROM	Customers C, Orders O
	WHERE	O.CustomerID = C.CustomerID
	AND		C.CompanyName = @Name
	AND		CAST(O.OrderDate AS DATE) = @Date
END
GO

EXEC SP_OrderByNameDate @Name = 'Eastern Connection', @Date = '1/1/1997'
DROP PROC SP_OrderByNameDate

--18.Tương tự nhưng năm được nhập từ bàn phím; trong đó nếu không nhập năm mà
--chỉ Enter thì sẽ lấy năm hiện tại để tính.
CREATE PROC SP_OrderByCustomerYear @Name NVARCHAR(40), @Year INT = NULL
AS
BEGIN
	IF @Year IS NULL
		SET @Year = YEAR(GETDATE())
	SELECT	* 
	FROM	Customers C, Orders O
	WHERE	O.CustomerID = C.CustomerID
	AND		C.CompanyName = @Name
	AND		YEAR(O.OrderDate) = @Year
END
GO

EXEC SP_OrderByCustomerYear @Name = 'Eastern Connection'
DROP PROC SP_OrderByCustomerYear

--19.Người ta muốn biết trong một ngày nào đó (nếu chỉ Enter là ngày hiện tại) tổng số
--đơn đặt hàng và doanh số cuả các đơn hàng đó là bao nhiêu. Thí dụ nhập 7 thang
--4 nam 1998 thì kết quả sẽ là:
CREATE PROC SP_SumOfOrdersandRevenue @Date DATE = NULL
AS
BEGIN
	IF @Date IS NULL
		SET @Date = CAST(GETDATE() AS DATE)
	SELECT	O.OrderDate,
			COUNT(DISTINCT O.OrderID) AS TotalOrders,
			SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TotalRevenue
	FROM	Orders O, [Order Details] OD
	WHERE	O.OrderID = OD.OrderID
	AND		O.OrderDate = @Date
	GROUP BY O.OrderDate
END
GO

EXEC SP_SumOfOrdersandRevenue @Date = '1/5/1997'
DROP PROC SP_SumOfOrdersandRevenue