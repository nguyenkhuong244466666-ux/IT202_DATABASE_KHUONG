CREATE DATABASE rikkeiclinicdb;
USE rikkeiclinicdb;

CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    date_of_birth DATE
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(18,2) NOT NULL
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

CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES employees(employee_id)
);

CREATE TABLE inventory (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0
);

CREATE TABLE medicines (
    medicine_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

CREATE TABLE patient_invoices (
    patient_id INT PRIMARY KEY,
    total_due DECIMAL(18,2) NOT NULL DEFAULT 0,
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

CREATE TABLE services (
    service_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(18,2) NOT NULL
);

CREATE TABLE wallets (
    patient_id INT PRIMARY KEY,
    balance DECIMAL(18,2) NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE service_usages (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    service_id INT NOT NULL,
    actual_price DECIMAL(18,2) DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (service_id) REFERENCES services(service_id)
);

INSERT INTO patients (patient_id, full_name, phone, date_of_birth) VALUES
(1, 'Nguyen Van An', '0901111222', '1990-05-15'),
(2, 'Tran Thi Binh', '0912222333', '1985-08-20'),
(3, 'Le Hoang Cuong', '0923333444', '2000-12-01');

INSERT INTO employees (employee_id, full_name, position, salary) VALUES
(101, 'Dr. Hoang Minh', 'Doctor', 20000.00),
(102, 'Dr. Lan Anh', 'Doctor', 25000.00),
(103, 'Nurse Thu Ha', 'Nurse', 12000.00);

INSERT INTO departments (dept_id, dept_name) VALUES
(1, 'Khoa Ngoai'),
(2, 'Khoa Noi'),
(3, 'Khoa ICU');

INSERT INTO beds (bed_id, dept_id, patient_id) VALUES
(101, 1, 1),
(201, 2, NULL),
(301, 3, 2);

INSERT INTO appointments (appointment_id, patient_id, doctor_id, appointment_date, status) VALUES
(104, 1, 101, '2026-06-10 08:30:00', 'Pending'),
(105, 2, 102, '2026-05-01 09:00:00', 'Completed'),
(106, 3, 101, '2026-05-02 10:00:00', 'Cancelled');

INSERT INTO inventory (item_id, item_name, stock_quantity) VALUES
(10, 'Khau trang y te N95', 1000),
(11, 'Gang tay vo trung', 500),
(12, 'Dung dich sat khuan', 200);

INSERT INTO medicines (medicine_id, name, price, stock) VALUES
(1, 'Amoxicillin 500mg', 15000, 100),
(2, 'Panadol Extra', 5000, 5);

INSERT INTO patient_invoices (patient_id, total_due) VALUES
(1, 1500000.00),
(2, 0),
(3, 0);

INSERT INTO products (name, price, stock) VALUES
('May do huyet ap Omron', 850000.00, 20),
('May do duong huyet', 450000.00, 15);

INSERT INTO services (service_id, name, price) VALUES
(1, 'Sieu am o bung', 200000.00),
(2, 'Xet nghiem mau', 150000.00),
(3, 'Chup X-Quang', 250000.00);

INSERT INTO wallets (patient_id, balance, status) VALUES
(1, 500000.00, 'Active'),
(2, 50000.00, 'Active'),
(3, 1000000.00, 'Inactive');

DELIMITER //

CREATE PROCEDURE payhospitalfee(
    IN p_patient_id INT,
    IN p_amount DECIMAL(18,2)
)
BEGIN
    UPDATE wallets
    SET balance = balance - p_amount
    WHERE patient_id = p_patient_id;

    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Loi: He thong gap su co mang dot ngot';

    UPDATE patient_invoices
    SET total_due = total_due - p_amount
    WHERE patient_id = p_patient_id;
END //

DELIMITER ;

CALL payhospitalfee(1,200000);

SELECT *
FROM wallets
WHERE patient_id = 1;

SELECT *
FROM patient_invoices
WHERE patient_id = 1;

DROP PROCEDURE IF EXISTS payhospitalfee;

DELIMITER //

CREATE PROCEDURE payhospitalfee(
    IN p_patient_id INT,
    IN p_amount DECIMAL(18,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE wallets
    SET balance = balance - p_amount
    WHERE patient_id = p_patient_id;

    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Loi: He thong gap su co mang dot ngot';

    UPDATE patient_invoices
    SET total_due = total_due - p_amount
    WHERE patient_id = p_patient_id;

    COMMIT;
END //

DELIMITER ;

CALL payhospitalfee(1,200000);

SELECT *
FROM wallets
WHERE patient_id = 1;

SELECT *
FROM patient_invoices
WHERE patient_id = 1;