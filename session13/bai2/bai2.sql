USE RikkeiClinicDB;

UPDATE Appointments
SET status = 'Completed'
WHERE appointment_id = 104;

OLD chứa dữ liệu trước khi UPDATE.
NEW chứa dữ liệu sau khi UPDATE.

Để kiểm tra lịch khám đã hoàn thành từ trước hay chưa phải dùng OLD.status.
Trigger cũ dùng NEW.status nên khi cập nhật từ Pending sang Completed cũng bị chặn.

DROP TRIGGER IF EXISTS PreventStatusRevert;

DELIMITER //

CREATE TRIGGER PreventStatusRevert
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN

    IF OLD.status = 'Completed' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Không được thay đổi lịch khám đã Completed';
    END IF;

END //

DELIMITER ;

UPDATE Appointments
SET status = 'Completed'
WHERE appointment_id = 104;

UPDATE Appointments
SET status = 'Cancelled'
WHERE appointment_id = 105;