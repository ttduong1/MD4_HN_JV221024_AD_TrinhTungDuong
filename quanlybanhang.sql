-- Bài 1: Tạo cơ sở dữ liệu: 

create database QUANLYBANHANG;
use QUANLYBANHANG;

create table CUSTOMERS(
customer_id varchar(4) primary key,
name varchar(100),
email varchar(100) not null,
phone varchar(25) not null,
address varchar(255)
);
alter table CUSTOMERS
add constraint unique_email unique (email),
add constraint unique_phone unique (phone);

create table ORDERS(
order_id varchar(4) primary key,
customer_id varchar(4),
foreign key(customer_id) references CUSTOMERS (customer_id),
order_date date,
total_amount double
);

create table PRODUCTS(
product_id varchar(4) primary key,
name varchar(255),
description text,
price double,
status bit(1)
);

CREATE TABLE ORDERS_DETAILS(
  order_id VARCHAR(4),
  product_id VARCHAR(4),
  quantity INT(11),
  price DOUBLE,
  PRIMARY KEY (order_id, product_id),
  FOREIGN KEY (order_id) REFERENCES ORDERS (order_id),
  FOREIGN KEY (product_id) REFERENCES PRODUCTS (product_id)
);

-- Bài 2: Thêm dữ liệu: 

-- Bảng CUSTOMERS:
insert into CUSTOMERS(customer_id, name, email, phone, address) values
("C001", "Nguyễn Trung Mạnh", "manhnt@gmail.com", "984756322", "Cầu Giấy, Hà Nội"),
("C002", "Hồ Hải Nam", "namhh@gmail.com", "984875926", "Ba Vì, Hà Nội"),
("C003", "Tô Ngọc Vũ", "vutn@gmail.com", "904725784", "Mộc Châu, Sơn La"),
("C004", "Phạm Ngọc Anh", "anhpn@gmail.com", "984635365", "Vinh, Nghê An"),
("C005", "Trương Minh Cường", "cuongtm@gmail.com", "989735624", "Hai Bà Trưng, Hà Nội");
select * from CUSTOMERS;

-- Bảng PRODUCTS:
insert into PRODUCTS (product_id, name, description, price) values
("P001", "Iphone 13 ProMax", "Bản 512 GB, xanh lá", 22999999),
("P002", "Dell Vostro V3510", "Core i5, RAM 8GB", 14999999),
("P003", "Macbook Pro M2", "8CPU 10GPU 8GB 256GB", 28999999),
("P004", "Apple Watch Ultra", "Titanium Alpine Loop Small", 18999999),
("P005", "Airpods 2 2022", "Spatial Audio", 4090000);
update PRODUCTS
set status = 1
where product_id in ('P001', 'P002', 'P003', 'P004', 'P005');
select * from PRODUCTS;

-- + Bảng ORDERS:
insert into ORDERS(order_id, customer_id, total_amount, order_date) values
("H001", "C001", 52999997, '2023/02/22'),
("H002", "C001", 80999997, '2023/03/11'),
("H003", "C002", 54359998, '2023/01/22'),
("H004", "C003", 102999995, '2023/03/14'),
("H005", "C003", 80999997, '2023/03/12'),
("H006", "C004", 110449994, '2023/02/01'),
("H007", "C004", 79999996, '2023/03/29'),
("H008", "C005", 29999998, '2023/02/14'),
("H009", "C005", 28999999, '2023/01/10'),
("H010", "C005", 149999994, '2023/04/01');
alter table orders_details add constraint orders_details_ibfk_1
    foreign key (order_id) references ORDERS(order_id);
select * from ORDERS;
    
-- + Bảng ORDERS_DETAILS:
insert into ORDERS_DETAILS(order_id, product_id, price, quantity) values
("H001", "P002", 14999999, 1),
("H001", "P004", 18999999, 2),
("H002", "P001", 22999999, 1),
("H002", "P003", 28999999, 2),
("H003", "P004", 18999999, 2),
("H003", "P005", 4090000, 4),
("H004", "P002", 14999999, 3),
("H004", "P003", 28999999, 2),
("H005", "P001", 22999999, 1),
("H005", "P003", 28999999, 2),
("H006", "P005", 4090000, 5),
("H006", "P002", 14999999, 6),
("H007", "P004", 18999999, 3),
("H007", "P001", 22999999, 1),
("H008", "P002", 14999999, 2),
("H009", "P003", 28999999, 1),
("H010", "P003", 28999999, 2),
("H010", "P001", 22999999, 4);
select * from ORDERS_DETAILS;

-- Bài 3: Truy vấn dữ liệu: 

-- Bài 3.1: Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .
select name, email, phone, address
from CUSTOMERS;

-- Bài 3.2: Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng).
select c.name, c.phone, c.address
from ORDERS o
join CUSTOMERS c ON o.customer_id = c.customer_id
where month(o.order_date) = 3 and year(o.order_date) = 2023;

-- Bài 3.3: Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm tháng và tổng doanh thu ).
select month(order_date) as month, SUM(total_amount) as total_revenue
from ORDERS
where year(order_date) = 2023
group by month(order_date)
order by month(order_date);

-- Bài 3.4: Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách hàng, địa chỉ , email và số điên thoại).
select c.name, c.address, c.email, c.phone
from CUSTOMERS c
where c.customer_id not in (
    select o.customer_id
    from ORDERS o
    where month(o.order_date) = 2 and year(o.order_date) = 2023
);

-- Bài 3.5: Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã sản phẩm, tên sản phẩm và số lượng bán ra).
select od.product_id, p.name, SUM(od.quantity) as Amount_sold
from ORDERS o
join ORDERS_DETAILS od on o.order_id = od.order_id
join PRODUCTS p on od.product_id = p.product_id
where o.order_date >= '2023-03-01' and o.order_date <= '2023-03-31'
group by od.product_id, p.name;

-- Bài 3.6: Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu).
select c.customer_id, c.name, SUM(o.total_amount) as total_spending
from CUSTOMERS c
join ORDERS o on c.customer_id = o.customer_id
where o.order_date >= '2023-01-01' and o.order_date <= '2023-12-31'
group by c.customer_id, c.name
order by total_spending desc;

-- Bài 3.7: Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm).
select c.name as customer_name, o.total_amount, o.order_date, SUM(od.quantity) as total_quantity
from ORDERS o
join CUSTOMERS c on o.customer_id = c.customer_id
join ORDERS_DETAILS od on o.order_id = od.order_id
group by o.order_id
having SUM(od.quantity) >= 5;

-- Bài 4: Tạo View, Procedure.

-- Bài 4.1: Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng tiền và ngày tạo hoá đơn.
create view ORDER_INFO as
select C.name as 'name', C.phone as 'phone', C.address as 'address', O.total_amount as 'Total_amount', O.order_date as 'Order_date'
from ORDERS O
inner join CUSTOMERS C on O.customer_id = C.customer_id;
drop view ORDER_INFO;
select * from ORDER_INFO;

-- Bài 4.2: Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng số đơn đã đặt.
create view CUSTOMER_ORDER_INFO as
select C.name as 'name', C.phone as 'phone', C.address as 'address', COUNT(O.order_id) as 'Total number of orders placed'
from CUSTOMERS C
left join ORDERS O on C.customer_id = O.customer_id
group by C.customer_id, C.name, C.phone, C.address;
select * from CUSTOMER_ORDER_INFO;

-- Bài 4.3: Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã bán ra của mỗi sản phẩm.
create view PRODUCT_SALES_INFO as
select P.name as product_name, P.description, P.price, coalesce(SUM(OD.quantity), 0) as total_sold
from PRODUCTS P
left join ORDERS_DETAILS OD on P.product_id = OD.product_id
group by P.product_id;
select * from PRODUCT_SALES_INFO;

-- Bài 4.4: Đánh Index cho trường `phone` và `email` của bảng Customer.
-- Đánh Index cho trường phone
create index idx_phone on CUSTOMERS(phone);
-- Đánh Index cho trường email
create index idx_email on CUSTOMERS(email);

-- Bài 4.5: Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.
DELIMITER //
create procedure GetCustomerInfo(IN p_customer_id char(4))
begin
    select * from CUSTOMERS where customer_id = p_customer_id;
    select * from ORDERS where customer_id = p_customer_id;
    select * from ORDERS_DETAILS where order_id in (select order_id from ORDERS where customer_id = p_customer_id);
end //
DELIMITER ;
call GetCustomerInfo('C001');
