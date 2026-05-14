CREATE DATABASE RikkeiClinicDB;
USE RikkeiClinicDB;

SELECT *
FROM Appointments;

CALL CancelAppointment(3);

/*
========================================================
PHẦN A - PHÂN TÍCH LỖI
========================================================

1. Câu lệnh CALL để tái hiện lỗi

CALL CancelAppointment(3);

Giả sử:
- appointment_id = 3
- trạng thái hiện tại là 'Completed'

Kết quả:
=> Procedure vẫn cập nhật thành 'Cancelled'

========================================================

2. Vì sao lỗi xảy ra?

Procedure cũ chỉ kiểm tra:
WHERE appointment_id = p_appointment_id

=> Không kiểm tra trạng thái hiện tại.

Vì vậy:
- Pending
- Completed
- Confirmed

đều có thể bị đổi sang 'Cancelled'.

=> Sai logic nghiệp vụ.

========================================================
*/

DROP PROCEDURE IF EXISTS CancelAppointment;

DELIMITER //

CREATE PROCEDURE CancelAppointment(IN p_appointment_id INT)

BEGIN

    UPDATE Appointments
    SET status = 'Cancelled'

    WHERE appointment_id = p_appointment_id
    AND status = 'Pending';

    IF ROW_COUNT() = 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Chi duoc huy lich hen dang o trang thai Pending';

    END IF;

END //

DELIMITER ;

SELECT *
FROM Appointments;

CALL CancelAppointment(1);

CALL CancelAppointment(3);

/*
========================================================
PHẦN B - GIẢI THÍCH LOGIC ĐÃ SỬA
========================================================

1. Điều kiện mới

AND status = 'Pending'

=> Chỉ cho phép hủy lịch:
    đang chờ xử lý

========================================================

2. ROW_COUNT()

- Nếu UPDATE thành công:
    ROW_COUNT() > 0

- Nếu không có dòng nào được cập nhật:
    ROW_COUNT() = 0

========================================================

3. SIGNAL SQLSTATE

Dùng để chủ động báo lỗi nghiệp vụ.

Ví dụ:
- Lịch đã Completed
- Hoặc appointment_id không tồn tại

=> Database trả lỗi:
'Chi duoc huy lich hen dang o trang thai Pending'

========================================================

4. Kết quả cuối cùng

- Pending:
    hủy được

- Completed:
    không hủy được

=> Đúng quy tắc hệ thống

========================================================
*/