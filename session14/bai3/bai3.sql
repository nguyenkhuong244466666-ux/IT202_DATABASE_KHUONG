CREATE DATABASE rikkeiclinicdb;
USE rikkeiclinicdb;

CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    full_name VARCHAR(100)
);

CREATE TABLE medicines (
    medicine_id INT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(18,2),
    stock INT
);

CREATE TABLE patient_invoices (
    patient_id INT PRIMARY KEY,
    total_due DECIMAL(18,2)
);

INSERT INTO patients VALUES
(1,'Nguyen Van An'),
(2,'Tran Thi Binh');

INSERT INTO medicines VALUES
(1,'Amoxicillin',15000,100),
(2,'Panadol',5000,5);

INSERT INTO patient_invoices VALUES
(1,0),
(2,0);

DELIMITER //

CREATE PROCEDURE dispensemedicine(
    IN p_patient_id INT,
    IN p_medicine_id INT,
    IN p_quantity INT,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_stock INT;
    DECLARE v_price DECIMAL(18,2);
    DECLARE v_total DECIMAL(18,2);

    START TRANSACTION;

    SELECT stock, price
    INTO v_stock, v_price
    FROM medicines
    WHERE medicine_id = p_medicine_id;

    IF p_quantity > v_stock THEN
        ROLLBACK;
        SET p_message = 'Loi: So luong ton kho khong du';
    ELSE
        UPDATE medicines
        SET stock = stock - p_quantity
        WHERE medicine_id = p_medicine_id;

        SET v_total = p_quantity * v_price;

        UPDATE patient_invoices
        SET total_due = total_due + v_total
        WHERE patient_id = p_patient_id;

        COMMIT;

        SET p_message = 'Da cap phat thanh cong';
    END IF;
END //

DELIMITER ;

CALL dispensemedicine(1,1,10,@msg);
SELECT @msg;

CALL dispensemedicine(1,2,10,@msg);
SELECT @msg;

SELECT * FROM medicines;
SELECT * FROM patient_invoices;