# SQL-Northwind Project

## 📌 Giới thiệu
Dự án này tập trung vào việc thực hành và giải quyết các bài toán kinh doanh thực tế thông qua việc truy vấn và phân tích dữ liệu trên cơ sở dữ liệu mẫu **Northwind Traders**. Hệ quản trị cơ sở dữ liệu được sử dụng là **SQL Server**.

## 📂 Cấu trúc Repository
* **Northwind.sql**: Tệp tin chứa mã nguồn để khởi tạo cấu trúc bảng và dữ liệu mẫu cho cơ sở dữ liệu Northwind.
* **A-Truy-van.sql**: Tập hợp các câu lệnh SQL phân tích dữ liệu từ cơ bản đến nâng cao.
* **B-Ma-kich-ban.sql**: Các kịch bản xử lý nghiệp vụ thông qua Stored Procedures (Thủ tục lưu trữ).

## 🛠 Các kỹ năng SQL đã áp dụng
Dự án bao gồm nhiều kỹ thuật xử lý dữ liệu quan trọng như:
* **Truy vấn cơ bản & Lọc dữ liệu**: Sử dụng `SELECT`, `WHERE`, `LIKE`, `IN`, `BETWEEN`.
* **Phân tích nâng cao**: Sử dụng các hàm gộp `SUM`, `AVG`, `COUNT`, `ROUND` kết hợp với `GROUP BY` và `HAVING` để tính toán doanh số và hiệu suất kinh doanh.
* **Liên kết bảng (Joins)**: Kết hợp dữ liệu từ nhiều bảng như `Customers`, `Orders`, `Order Details`, `Products`, `Employees` và `Categories`.
* **Lập trình SQL (Stored Procedures)**:
    * Tạo các thủ tục có tham số đầu vào để lọc sản phẩm theo danh mục hoặc theo khoảng thời gian.
    * Xử lý logic điều kiện với khối lệnh `IF...ELSE`, `CASE WHEN`.
    * Thiết lập giá trị mặc định cho tham số (ví dụ: lấy năm hiện tại nếu không nhập năm).
* **Phân tích doanh thu**: Tính toán giá trị đơn hàng, tiền giảm giá, phí vận chuyển và tỷ lệ phần trăm doanh số theo từng khách hàng.

## 📊 Một số bài toán tiêu biểu đã giải quyết
* **Quản lý khách hàng**: Liệt kê danh sách khách hàng theo chức vụ và quốc gia cụ thể (ví dụ: Sales Manager tại USA hoặc Owner tại Mexico).
* **Phân tích bán hàng**:
    * Tính tổng doanh số của từng loại sản phẩm trong năm 1996.
    * Tính tỷ lệ tiền cước vận chuyển (Freight) so với doanh số của khách hàng trong năm 1997.
* **Quản lý nhân sự**: Theo dõi số lượng đơn hàng từng nhân viên lập trong năm và đưa ra cảnh báo nếu số lượng đơn quá thấp (< 20 đơn).
* **Báo cáo kho vận**: Xác định các sản phẩm được đặt hàng nhiều nhất và ít nhất trong các khoảng thời gian cụ thể.

## 🚀 Cách sử dụng
1.  Chạy tệp `Northwind.sql` để thiết lập cơ sở dữ liệu.
2.  Tham khảo các câu truy vấn mẫu trong tệp `A-Truy-van.sql`.
3.  Thực thi các Stored Procedure trong tệp `B-Ma-kich-ban.sql` để thực hiện các báo cáo động theo tham số.

---
*Dự án được xây dựng bởi yenoren11.*
