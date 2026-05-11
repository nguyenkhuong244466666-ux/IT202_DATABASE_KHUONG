CREATE DATABASE hackathon;
USE hackathon;

CREATE TABLE customers(
	cus_id VARCHAR(5) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE
);

CREATE TABLE brands(
	br_id VARCHAR(5) PRIMARY KEY,
    br_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE products(
	pro_id VARCHAR(5) PRIMARY KEY,
    pro_name VARCHAR(100) NOT NULL UNIQUE,
    br_id VARCHAR(5),
    price DECIMAL(10,2),
    stock INT NOT NULL CHECK(stock>=0),
    FOREIGN KEY(br_id) REFERENCES brands(br_id)
);

CREATE TABLE orders(
	or_id INT PRIMARY KEY AUTO_INCREMENT,
    cus_id VARCHAR(5),
    pro_id VARCHAR(5),
    or_status VARCHAR(20) NOT NULL CHECK(or_status IN ('pending','completed','cancelled')), 
    or_date DATE NOT NULL,
	FOREIGN KEY(cus_id) REFERENCES customers(cus_id),
	FOREIGN KEY(pro_id) REFERENCES products(pro_id)
);

-- them du lieu

INSERT INTO customers
VALUES 
('C01','Nguyễn Văn An','an.nv@gmail.com','0911111111'),
('C02','Nguyễn Thị Mai','mai.nt@gmail.com','0922222222'),
('C03','Trần Quang Hải','hai.tq@gmail.com','0933333333'),
('C04','Phạm Bảo Ngọc','ngoc.pb@gmail.com','0944444444'),
('C05','Vũ Đức Đam','dam.vd@gmail.com','0955555555');

INSERT INTO brands
VALUES 
('B01','Apple'),
('B02','Samsung'),
('B03','Sony'),
('B04','Dell');

INSERT INTO products
VALUES 
('P01','Iphone 15 Pro Max','B01',30000000,10),
('P02','MacBook Pro M3','B01',45000000,5),
('P03','Galaxy S24 Ultra','B02',25000000,20),
('P04','PlayStation 5','B03',15000000,8),
('P05','Dell XPS 15','B04',35000000,15);

INSERT INTO orders
VALUES 
(1,'C01','P01','pending','2025-10-01'),
(2,'C02','P03','completed','2025-10-02'),
(3,'C01','P02','completed','2025-10-03'),
(4,'C04','P05','cancelled','2025-10-04'),
(5,'C05','P01','pending','2025-10-05');

UPDATE products
SET stock= stock+10, price=price*1.05
WHERE pro_id ='P05';

UPDATE customers
SET phone='0999999999'
Where cus_id='C03';

DELETE FROM orders 
WHERE or_status='completed' AND or_date <'2025-10-03'; 

-- TRUY VAN CO BAN

SELECT pro_id,pro_name
FROM products 
WHERE price >=15000000 AND price <= 30000000;

SELECT full_name, email
FROM customers
WHERE full_name LIKE 'Nguyễn%';

SELECT or_id, cus_id, or_date
FROM orders
ORDER BY or_date DESC;

SELECT pro_name, price
FROM products
ORDER BY price DESC
LIMIT 3;

SELECT pro_name, stock
FROM products 
LIMIT 2 OFFSET 2;

-- TRUY VAN NANG CAO

SELECT or_id, full_name,pro_name, or_date
FROM customers c
INNER JOIN orders o
ON c.cus_id=o.cus_id
INNER JOIN products p
ON o.pro_id=p.pro_id
WHERE or_status = 'pending';

SELECT br_name
FROM brands b
INNER JOIN products p
ON b.br_id = p.br_id
WHERE b.br_id NOT IN (SELECT p.br_id FROM products);

SELECT or_status, count(or_status) as total_orders
FROM orders
GROUP BY or_status;

SELECT pro_id, pro_name,price
FROM products 
WHERE price < ( SELECT AVG(price) FROM products);

SELECT full_name, phone 
FROM customers c
INNER JOIN products p
ON c.cus_id=p.cus_id
WHERE p.pro_name='Iphone 15 Pro Max';
