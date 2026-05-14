CREATE DATABASE HospitalBillingDB;
USE HospitalBillingDB;

CREATE TABLE Bills (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_name VARCHAR(100),
    total_cost DECIMAL(12,2),
    patient_type VARCHAR(20)
);

INSERT INTO Bills (patient_name, total_cost, patient_type)
VALUES
('Nguyen Van A', 5000000, 'BHYT'),
('Tran Thi B', 8000000, 'VIP'),
('Le Van C', 3000000, 'THUONG');

DROP PROCEDURE IF EXISTS CalculateDischargeFee;

DELIMITER //

CREATE PROCEDURE CalculateDischargeFee(
    IN p_total_cost DECIMAL(12,2),
    IN p_patient_type VARCHAR(20),
    OUT p_final_amount DECIMAL(12,2),
    OUT p_message VARCHAR(100)
)
BEGIN

    IF p_total_cost < 0 THEN

        SET p_final_amount = 0;
        SET p_message = 'Loi: Chi phi khong hop le';

    ELSEIF p_patient_type = 'BHYT' THEN

        SET p_final_amount = p_total_cost * 0.2;
        SET p_message = 'Da tinh toan xong';

    ELSEIF p_patient_type = 'VIP' THEN

        SET p_final_amount = p_total_cost * 0.9;
        SET p_message = 'Da tinh toan xong';

    ELSEIF p_patient_type = 'THUONG' THEN

        SET p_final_amount = p_total_cost;
        SET p_message = 'Da tinh toan xong';

    ELSE

        SET p_final_amount = 0;
        SET p_message = 'Loai benh nhan khong hop le';

    END IF;

END //

DELIMITER ;

CALL CalculateDischargeFee(
    10000000,
    'BHYT',
    @final_amount,
    @message
);

SELECT @final_amount AS final_amount, @message AS message;

CALL CalculateDischargeFee(
    10000000,
    'VIP',
    @final_amount,
    @message
);

SELECT @final_amount AS final_amount, @message AS message;

CALL CalculateDischargeFee(
    10000000,
    'THUONG',
    @final_amount,
    @message
);

SELECT @final_amount AS final_amount, @message AS message;

CALL CalculateDischargeFee(
    -500000,
    'VIP',
    @final_amount,
    @message
);

SELECT @final_amount AS final_amount, @message AS message;