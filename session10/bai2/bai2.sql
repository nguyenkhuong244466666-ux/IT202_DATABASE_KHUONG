CREATE DATABASE hospital_index_demo;
USE hospital_index_demo;

CREATE TABLE Patients (
    Patient_ID INT AUTO_INCREMENT PRIMARY KEY,
    Full_Name VARCHAR(100),
    Phone VARCHAR(20),
    Age INT,
    Address VARCHAR(255)
);

DELIMITER //

CREATE PROCEDURE SeedPatients()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 500000 DO

        INSERT INTO Patients (Full_Name, Phone, Age, Address)
        VALUES (
            CONCAT('Patient ', i),
            CONCAT('090', LPAD(i,7,'0')),
            FLOOR(RAND() * 100),
            'Ho Chi Minh City'
        );

        SET i = i + 1;

    END WHILE;

END //

DELIMITER ;

CALL SeedPatients();

SELECT COUNT(*) AS total_patients
FROM Patients;

SET profiling = 1;

EXPLAIN
SELECT *
FROM Patients
WHERE Phone = '0900001000';

SELECT *
FROM Patients
WHERE Phone = '0900001000';

SHOW PROFILES;

CREATE INDEX idx_phone
ON Patients(Phone);

SHOW INDEX FROM Patients;

EXPLAIN
SELECT *
FROM Patients
WHERE Phone = '0900001000';

SELECT *
FROM Patients
WHERE Phone = '0900001000';

SHOW PROFILES;

DROP PROCEDURE IF EXISTS InsertWithoutIndex;

DELIMITER //

CREATE PROCEDURE InsertWithoutIndex()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 1000 DO

        INSERT INTO Patients (Full_Name, Phone, Age, Address)
        VALUES (
            CONCAT('NoIndex ', i),
            CONCAT('099', LPAD(i,7,'0')),
            FLOOR(RAND() * 100),
            'Ha Noi'
        );

        SET i = i + 1;

    END WHILE;

END //

DELIMITER ;

ALTER TABLE Patients DROP INDEX idx_phone;

SET profiling = 1;

CALL InsertWithoutIndex();

SHOW PROFILES;

CREATE INDEX idx_phone
ON Patients(Phone);

DROP PROCEDURE IF EXISTS InsertWithIndex;

DELIMITER //

CREATE PROCEDURE InsertWithIndex()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 1000 DO

        INSERT INTO Patients (Full_Name, Phone, Age, Address)
        VALUES (
            CONCAT('WithIndex ', i),
            CONCAT('088', LPAD(i,7,'0')),
            FLOOR(RAND() * 100),
            'Da Nang'
        );

        SET i = i + 1;

    END WHILE;

END //

DELIMITER ;

SET profiling = 1;

CALL InsertWithIndex();

SHOW PROFILES;