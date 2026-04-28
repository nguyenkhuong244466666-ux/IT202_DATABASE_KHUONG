CREATE DATABASE  quanlyhethongbanhang;
USE quanlyhethongbanhang;

CREATE TABLE product(
	pro_id INT PRIMARY KEY AUTO_INCREMENT,
    pro_name VARCHAR(100) NOT NULL UNIQUE,
    hang_sx VARCHAR(100) NOT NULL,
    price DECIMAL(15,2) NOT NULL,
    quantity INT NOT NULL
);

CREATE TABLE customer(
	cus_id INT PRIMARY KEY AUTO_INCREMENT,
    cus_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(11) NOT NULL UNIQUE,
    dc VARCHAR(200) NOT NULL 
);

CREATE TABLE oder(
	oder_id INT PRIMARY KEY AUTO_INCREMENT,
    oder_date DATE,
    price DECIMAL(15,2),
    cus_id INT,
    CONSTRAINT FOREIGN KEY(cus_id) REFERENCES customer(cus_id)
);

CREATE TABLE oder_detail(
	oder_id INT,
    pro_id INT,
    quantity_oder INT,
    price DECIMAL(15,2),
    PRIMARY KEY (oder_id,pro_id),
    FOREIGN KEY (oder_id) REFERENCES oder(oder_id),
	FOREIGN KEY (pro_id) REFERENCES product(pro_id)
);

ALTER TABLE oder ADD ghichu VARCHAR(200);

ALTER TABLE product
RENAME COLUMN hang_sx TO nhasanxuat;

DROP  TABLE oder_detail;
DROP TABLE oder;

INSERT INTO product
VALUES (1,'MAC','apple',30000000,10),
	   (2,'IP15','apple',30000000,38),
	   (3,'IP14','apple',27000000,4),
	   (4,'IP12','apple',20000000,5),
	   (5,'IPXSM','apple',10000000,2);
       
INSERT INTO customer
VALUES (1,'Nguyen khuong','khuong@gmail.com','0866986754','Long An'),
	   (2,'Nguyen A','khuong123@gmail.com','0764783647','Ha Noi'),
	   (3,'Nguyen B','khuong12@gmail.com','0866986787','TP HCM'),
	   (4,'Nguyen C','khuongc@gmail.com','0768495765','Da Nang'),
	   (5,'Nguyen D','khuongd@gmail.com','0866986123','Hue');
       
INSERT INTO oder
VALUES (1,'2026-01-01',28500000,'1',NULL),
	   (2,'2026-01-03',30500000,'2',NULL),
	   (3,'2026-01-04',31500000,'3',NULL),
	   (4,'2026-01-05',32500000,'4',NULL),
	   (5,'2026-01-06',33500000,'5',NULL);
       
INSERT INTO oder_detail
VALUES (1,1,1,30000000),
	   (2,2,1,30000000),
	   (3,3,1,27000000),
	   (4,4,1,20000000),
	   (5,5,1,10000000);
       
UPDATE product 
SET price=price*1.1
WHERE nhasanxuat='apple';

DELETE FROM customer
WHERE sdt IS NULL;

SELECT * FROM product
WHERE price BETWEEN 10000000 AND 20000000;

SELECT * FROM product
WHERE pro_id=1;

SELECT * FROM customer 
WHERE dc='TP HCM';



       













