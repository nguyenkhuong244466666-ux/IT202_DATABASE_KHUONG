CREATE DATABASE book_worm;
USE book_worm;

DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS authors;
DROP TABLE IF EXISTS customers;

CREATE TABLE authors(
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    birth_year INT,
    nationality VARCHAR(100)
);

CREATE TABLE books(
    id INT PRIMARY KEY AUTO_INCREMENT,
    book_name VARCHAR(200) NOT NULL,
    category VARCHAR(100),
    author_id INT,
    price DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK(price >= 0),
    publish_year INT,
    FOREIGN KEY(author_id) REFERENCES authors(id)
);

CREATE TABLE customers(
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,
    registration_date DATE DEFAULT (CURRENT_DATE)
);

INSERT INTO authors(full_name, birth_year, nationality) VALUES
('Nguyen Nhat Anh', 1955, 'Viet Nam'),
('J.K. Rowling', 1965, 'Anh'),
('Haruki Murakami', 1949, 'Nhat Ban');

INSERT INTO books(book_name, category, author_id, price, publish_year) VALUES
('Mat Biec', 'Tieu thuyet', 1, 80000, 2010),
('Harry Potter', 'Fantasy', 2, 150000, 1997),
('Norwegian Wood', 'Tieu thuyet', 3, 120000, 1987);

INSERT INTO customers(full_name, email, phone) VALUES
('Nguyen Van A', 'a@gmail.com', '0123456789'),
('Tran Thi B', 'b@gmail.com', '0987654321');

UPDATE books
SET price = 90000
WHERE id = 1;

DELETE FROM books
WHERE id = 3;

SELECT * FROM authors;

SELECT * FROM books;

SELECT * FROM customers;

SELECT b.book_name, a.full_name, b.price
FROM books b
JOIN authors a ON b.author_id = a.id;