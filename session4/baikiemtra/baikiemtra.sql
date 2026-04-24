CREATE DATABASE ShopManager;
USE ShopManager;

CREATE TABLE Categories(
	cat_id INT PRIMARY KEY AUTO_INCREMENT,
    cat_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Products(
	pro_id INT PRIMARY KEY AUTO_INCREMENT,
    pro_name VARCHAR(100) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL CHECK(stock>0),
    cat_id INT NOT NULL,
    CONSTRAINT FOREIGN KEY(cat_id) REFERENCES Categories(cat_id)
);

INSERT INTO Categories
VALUES (1,'điện tử'),(2,'thời trang');

INSERT INTO Products 
VALUES (1,'iPhone 15','25000000',10,1),(2,'Samsung S23','20000000',5,1),
	   (3,'Áo sơ mi nam','500000',50,2),(4,'Giày thể thao','1200000',20,2);
       
UPDATE Products 
SET price=26000000
WHERE pro_name='iPhone 15'; 

UPDATE Products
SET stock=stock+10 
WHERE cat_id=1;

DELETE FROM Products
WHERE pro_id=4 ;

DELETE FROM Products
WHERE price < 1000000;
 
SELECT * FROM Products;
SELECT * FROM Products 
WHERE stock >15 ;
SELECT * FROM Products
WHERE price BETWEEN 1000000 AND 25000000;
SELECT * FROM Products
WHERE pro_name!='iphone15'
AND stock>0;


