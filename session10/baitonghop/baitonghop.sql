CREATE DATABASE ss10;
USE ss10;

CREATE TABLE Patients (
    Patient_ID CHAR(5) PRIMARY KEY,
    Full_Name VARCHAR(100) NOT NULL,
    Admission_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Vitals_Logs (
    Log_ID INT AUTO_INCREMENT PRIMARY KEY,
    Patient_ID CHAR(5),
    Heart_Rate INT CHECK (Heart_Rate > 0),
    Blood_Pressure VARCHAR(20),
    Record_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID)
);

INSERT INTO Patients (Patient_ID, Full_Name)
VALUES
('P001', 'Nguyen Khuong'),
('P002', 'Trần Thị Mỹ'),
('P003', 'Lê Văn Phúc Sang');


INSERT INTO Vitals_Logs (Patient_ID, Heart_Rate, Blood_Pressure)
VALUES
('P001', 80, '120/80'),
('P001', 85, '118/79'),
('P002', 90, '130/85'),
('P003', 75, '115/76');

CREATE INDEX idx_patient_record
ON Vitals_Logs(Patient_ID, Record_Time);

CREATE VIEW ER_Dashboard_View AS
SELECT
    p.Patient_ID,
    p.Full_Name,
    p.Admission_Time,

    COALESCE(v.Heart_Rate, 'Pending') AS Heart_Rate,

    COALESCE(v.Blood_Pressure, 'Pending') AS Blood_Pressure,

    v.Record_Time,

    CASE
        WHEN v.Heart_Rate > 120 OR v.Heart_Rate < 50 THEN 'CRITICAL'
        WHEN v.Heart_Rate IS NULL THEN 'Pending'
        ELSE 'STABLE'
    END AS Urgency_Level

FROM Patients p

LEFT JOIN Vitals_Logs v
ON p.Patient_ID = v.Patient_ID

AND v.Record_Time =
(
    SELECT MAX(v2.Record_Time)
    FROM Vitals_Logs v2
    WHERE v2.Patient_ID = p.Patient_ID
);

SELECT *
FROM ER_Dashboard_View;

INSERT INTO Patients (Patient_ID, Full_Name)
VALUES
('P004', 'Pham Gia Bao');

SELECT *
FROM ER_Dashboard_View;

UPDATE ER_Dashboard_View
SET Heart_Rate = 200
WHERE Patient_ID = 'P001';

INSERT INTO ER_Dashboard_View
VALUES
('P005', 'Test', NOW(), 90, '120/80', NOW(), 'STABLE');






