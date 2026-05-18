CREATE DATABASE rikkeiclinicdb;
USE rikkeiclinicdb;

CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    full_name VARCHAR(100)
);

CREATE TABLE wallets (
    patient_id INT PRIMARY KEY,
    balance DECIMAL(18,2),
    status VARCHAR(20)
);

CREATE TABLE patient_invoices (
    patient_id INT PRIMARY KEY,
    total_due DECIMAL(18,2)
);

INSERT INTO patients VALUES
(1,'Nguyen Van An'),
(2,'Tran Thi Binh');

INSERT INTO wallets VALUES
(1,500000,'Active'),
(2,50000,'Active');

INSERT INTO patient_invoices VALUES
(1,300000),
(2,100000);

DELIMITER //

CREATE PROCEDURE payhospitalfee(
    IN p_patient_id INT,
    IN p_amount DECIMAL(18,2),
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_balance DECIMAL(18,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_message = 'Loi: Giao dich that bai';
    END;

    START TRANSACTION;

    IF p_amount <= 0 THEN
        ROLLBACK;
        SET p_message = 'Loi: So tien thanh toan khong hop le';
    ELSE

        SELECT balance
        INTO v_balance
        FROM wallets
        WHERE patient_id = p_patient_id;

        IF v_balance < p_amount THEN
            ROLLBACK;
            SET p_message = 'Loi: So du vi khong du';
        ELSE

            UPDATE wallets
            SET balance = balance - p_amount
            WHERE patient_id = p_patient_id;

            UPDATE patient_invoices
            SET total_due = total_due - p_amount
            WHERE patient_id = p_patient_id;

            COMMIT;

            SET p_message = 'Thanh toan thanh cong';

        END IF;

    END IF;

END //

DELIMITER ;

CALL payhospitalfee(1,100000,@msg);
SELECT @msg;

CALL payhospitalfee(2,100000,@msg);
SELECT @msg;

CALL payhospitalfee(1,-50000,@msg);
SELECT @msg;

SELECT * FROM wallets;
SELECT * FROM patient_invoices;