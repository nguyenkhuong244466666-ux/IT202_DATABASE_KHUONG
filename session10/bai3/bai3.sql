CREATE DATABASE hospital_finance;
USE hospital_finance;

CREATE TABLE Departments (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(100)
);

CREATE TABLE Patients (
    Patient_ID INT PRIMARY KEY,
    Full_Name VARCHAR(100),
    Age INT
);

CREATE TABLE Invoices (
    Invoice_ID INT PRIMARY KEY,
    Patient_ID INT,
    Dept_ID INT,
    Amount DECIMAL(10,2)
);

INSERT INTO Departments
VALUES
(1, 'Noi'),
(2, 'Ngoai'),
(3, 'Tim Mach');

INSERT INTO Patients
VALUES
(1, 'Nguyen Van A', 30),
(2, 'Tran Thi B', 40),
(3, 'Le Van C', 25),
(4, 'Pham Thi D', 50);

INSERT INTO Invoices
VALUES
(101, 1, 1, 500.00),
(102, 2, 1, 300.00),
(103, 3, 2, 1000.00),
(104, 4, 3, 2000.00),
(105, 1, 3, 1500.00);

CREATE VIEW Department_Revenue_View AS
SELECT
    d.Dept_Name,
    COUNT(DISTINCT i.Patient_ID) AS Total_Patients,
    SUM(i.Amount) AS Total_Revenue
FROM Departments d
JOIN Invoices i
ON d.Dept_ID = i.Dept_ID
JOIN Patients p
ON p.Patient_ID = i.Patient_ID
GROUP BY d.Dept_Name;

SELECT *
FROM Department_Revenue_View;

UPDATE Department_Revenue_View
SET Total_Revenue = 999999
WHERE Dept_Name = 'Noi';