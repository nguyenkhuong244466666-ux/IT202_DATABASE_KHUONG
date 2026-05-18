CREATE DATABASE rikkeiclinicdb;
USE rikkeiclinicdb;

CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    date_of_birth DATE
);

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

CREATE TABLE beds (
    bed_id INT PRIMARY KEY,
    dept_id INT NOT NULL,
    patient_id INT DEFAULT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

INSERT INTO patients (patient_id, full_name, phone, date_of_birth) VALUES
(1, 'Nguyen Van An', '0901111222', '1990-05-15'),
(2, 'Tran Thi Binh', '0912222333', '1985-08-20');

INSERT INTO departments (dept_id, dept_name) VALUES
(1, 'Khoa Ngoai'),
(2, 'Khoa Noi');

INSERT INTO beds (bed_id, dept_id, patient_id) VALUES
(101, 1, 1),
(201, 2, NULL);

DELIMITER //

CREATE PROCEDURE transferbed(
    IN p_patient_id INT,
    IN p_new_bed_id INT
)
BEGIN
    UPDATE beds
    SET patient_id = NULL
    WHERE patient_id = p_patient_id;

    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Loi: He thong bi mat ket noi';

    UPDATE beds
    SET patient_id = p_patient_id
    WHERE bed_id = p_new_bed_id;
END //

DELIMITER ;

CALL transferbed(1,201);

SELECT *
FROM beds;

DROP PROCEDURE IF EXISTS transferbed;

DELIMITER //

CREATE PROCEDURE transferbed(
    IN p_patient_id INT,
    IN p_new_bed_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE beds
    SET patient_id = NULL
    WHERE patient_id = p_patient_id;

    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Loi: He thong bi mat ket noi';

    UPDATE beds
    SET patient_id = p_patient_id
    WHERE bed_id = p_new_bed_id;

    COMMIT;
END //

DELIMITER ;

CALL transferbed(1,201);

SELECT *
FROM beds;