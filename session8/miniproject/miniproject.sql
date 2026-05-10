CREATE DATABASE SalesManagement;
USE SalesManagement;

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    gender TINYINT NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    birth_date DATE NOT NULL,
    customer_type VARCHAR(50) DEFAULT 'Normal'
);

CREATE TABLE Category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    category_id INT,
    FOREIGN KEY (category_id)
    REFERENCES Category(category_id)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (customer_id)
    REFERENCES Customer(customer_id)
);

CREATE TABLE Order_Detail (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (order_id)
    REFERENCES Orders(order_id),

    FOREIGN KEY (product_id)
    REFERENCES Product(product_id)
);

INSERT INTO Customer(full_name, gender, email, birth_date, customer_type)
VALUES
('Nguyen Van A', 1, 'a@gmail.com', '2001-05-10', 'VIP'),
('Tran Thi B', 0, 'b@gmail.com', '1998-02-20', 'Normal'),
('Le Van C', 1, 'c@gmail.com', '2005-11-01', 'VIP'),
('Pham Thi D', 0, 'd@gmail.com', '2003-07-15', 'Normal'),
('Hoang Van E', 1, 'e@gmail.com', '1995-01-01', 'VIP');

INSERT INTO Category(category_name)
VALUES
('Điện tử'),
('Thời trang'),
('Gia dụng'),
('Sách'),
('Thể thao');

INSERT INTO Product(product_name, price, stock, category_id)
VALUES
('Laptop Dell', 20000000, 10, 1),
('iPhone 15', 30000000, 5, 1),
('Áo Hoodie', 500000, 20, 2),
('Nồi cơm điện', 1500000, 8, 3),
('Giày thể thao', 1200000, 15, 5);

INSERT INTO Orders(customer_id, order_date, status)
VALUES
(1, '2026-05-01', 'Completed'),
(2, '2026-05-02', 'Completed'),
(1, '2026-05-03', 'Pending'),
(3, '2026-05-04', 'Completed'),
(5, '2026-05-05', 'Cancelled');

INSERT INTO Order_Detail(order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 20000000),
(1, 3, 2, 500000),
(2, 2, 1, 30000000),
(3, 4, 1, 1500000),
(4, 5, 2, 1200000);

UPDATE Product
SET price = 25000000
WHERE product_id = 1;

UPDATE Customer
SET email = 'newemail@gmail.com'
WHERE customer_id = 2;

DELETE FROM Orders
WHERE status = 'Cancelled';

SELECT
    full_name AS 'Họ tên',
    email AS 'Email',
    CASE
        WHEN gender = 1 THEN 'Nam'
        ELSE 'Nữ'
    END AS 'Giới tính'
FROM Customer;

SELECT
    full_name,
    YEAR(NOW()) - YEAR(birth_date) AS age
FROM Customer
ORDER BY age ASC
LIMIT 3;

SELECT
    o.order_id,
    c.full_name,
    o.order_date,
    o.status
FROM Orders o
INNER JOIN Customer c
ON o.customer_id = c.customer_id;

SELECT
    c.category_name,
    COUNT(p.product_id) AS total_product
FROM Category c
INNER JOIN Product p
ON c.category_id = p.category_id
GROUP BY c.category_name
HAVING COUNT(p.product_id) >= 2;

SELECT *
FROM Product
WHERE price > (
    SELECT AVG(price)
    FROM Product
);

SELECT *
FROM Customer
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM Orders
);

SELECT
    c.category_name,
    SUM(od.quantity * od.unit_price) AS revenue
FROM Category c
INNER JOIN Product p
ON c.category_id = p.category_id
INNER JOIN Order_Detail od
ON p.product_id = od.product_id
GROUP BY c.category_name
HAVING revenue > (
    SELECT AVG(total_revenue) * 1.2
    FROM (
        SELECT
            SUM(od.quantity * od.unit_price) AS total_revenue
        FROM Category c
        INNER JOIN Product p
        ON c.category_id = p.category_id
        INNER JOIN Order_Detail od
        ON p.product_id = od.product_id
        GROUP BY c.category_name
    ) AS temp
);

SELECT *
FROM Product p1
WHERE price = (
    SELECT MAX(price)
    FROM Product p2
    WHERE p1.category_id = p2.category_id
);

SELECT full_name
FROM Customer
WHERE customer_type = 'VIP'
AND customer_id IN (
    SELECT customer_id
    FROM Orders
    WHERE order_id IN (
        SELECT order_id
        FROM Order_Detail
        WHERE product_id IN (
            SELECT product_id
            FROM Product
            WHERE category_id = (
                SELECT category_id
                FROM Category
                WHERE category_name = 'Điện tử'
            )
        )
    )
);