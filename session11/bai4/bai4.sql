CREATE DATABASE HospitalDebtDB;
USE HospitalDebtDB;

CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    phone VARCHAR(20),
    total_debt DECIMAL(12,2)
);

INSERT INTO Patients
VALUES
(1, 'Nguyen Van A', '0901111111', 5000000),
(2, 'Tran Thi B', '0902222222', 1200000),
(3, 'Le Van C', '0903333333', 0);

DROP PROCEDURE IF EXISTS GetPatientDebt;

DELIMITER //

CREATE PROCEDURE GetPatientDebt(
    IN p_patient_id INT,
    IN p_phone VARCHAR(20),
    OUT p_total_debt DECIMAL(12,2),
    OUT p_message VARCHAR(100)
)
BEGIN

    IF p_patient_id IS NULL AND p_phone IS NULL THEN

        SET p_total_debt = 0;
        SET p_message = 'Loi: Vui long nhap ID hoac Phone';

    ELSEIF p_patient_id IS NOT NULL THEN

        SELECT total_debt
        INTO p_total_debt
        FROM Patients
        WHERE patient_id = p_patient_id
        LIMIT 1;

        IF p_total_debt IS NULL THEN
            SET p_total_debt = 0;
            SET p_message = 'Khong tim thay benh nhan';
        ELSE
            SET p_message = 'Tra cuu thanh cong';
        END IF;

    ELSEIF p_phone IS NOT NULL THEN

        SELECT total_debt
        INTO p_total_debt
        FROM Patients
        WHERE phone = p_phone
        LIMIT 1;

        IF p_total_debt IS NULL THEN
            SET p_total_debt = 0;
            SET p_message = 'Khong tim thay benh nhan';
        ELSE
            SET p_message = 'Tra cuu thanh cong';
        END IF;

    END IF;

END //

DELIMITER ;

CALL GetPatientDebt(
    1,
    NULL,
    @debt,
    @message
);

SELECT @debt AS total_debt, @message AS message;

CALL GetPatientDebt(
    NULL,
    '0902222222',
    @debt,
    @message
);

SELECT @debt AS total_debt, @message AS message;

CALL GetPatientDebt(
    NULL,
    NULL,
    @debt,
    @message
);

SELECT @debt AS total_debt, @message AS message;

CALL GetPatientDebt(
    999,
    NULL,
    @debt,
    @message
);

SELECT @debt AS total_debt, @message AS message;