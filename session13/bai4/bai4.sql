USE RikkeiClinicDB;

DROP TRIGGER IF EXISTS trg_PreventDoubleBooking_Insert;
DROP TRIGGER IF EXISTS trg_PreventDoubleBooking_Update;

DELIMITER //

CREATE TRIGGER trg_PreventDoubleBooking_Insert
BEFORE INSERT ON Appointments
FOR EACH ROW
BEGIN

    IF EXISTS
    (
        SELECT 1
        FROM Appointments
        WHERE doctor_id = NEW.doctor_id
        AND appointment_date = NEW.appointment_date
        AND status <> 'Cancelled'
    )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Bác sĩ đã có lịch hẹn vào khung giờ này';
    END IF;

END //

CREATE TRIGGER trg_PreventDoubleBooking_Update
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN

    IF EXISTS
    (
        SELECT 1
        FROM Appointments
        WHERE doctor_id = NEW.doctor_id
        AND appointment_date = NEW.appointment_date
        AND status <> 'Cancelled'
        AND appointment_id <> OLD.appointment_id
    )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Bác sĩ đã có lịch hẹn vào khung giờ này';
    END IF;

END //

DELIMITER ;

INSERT INTO Appointments
(
    appointment_id,
    patient_id,
    doctor_id,
    appointment_date,
    status
)
VALUES
(
    107,
    1,
    101,
    '2026-07-15 09:00:00',
    'Pending'
);

INSERT INTO Appointments
(
    appointment_id,
    patient_id,
    doctor_id,
    appointment_date,
    status
)
VALUES
(
    108,
    2,
    101,
    '2026-06-10 08:30:00',
    'Pending'
);

INSERT INTO Appointments
(
    appointment_id,
    patient_id,
    doctor_id,
    appointment_date,
    status
)
VALUES
(
    109,
    2,
    101,
    '2026-05-02 10:00:00',
    'Pending'
);

UPDATE Appointments
SET status = 'Completed'
WHERE appointment_id = 104;