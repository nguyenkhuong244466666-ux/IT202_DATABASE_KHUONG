USE RikkeiClinicDB;

SELECT *
FROM Inventory;

CALL AddInventory(10, -500);

/*
========================================================
PHẦN A - PHÂN TÍCH
========================================================

1. Câu lệnh tái hiện lỗi

CALL AddInventory(10, -500);

=> Nhân viên nhập nhầm số lượng âm.

========================================================

2. Vì sao bị mất hàng trong kho?

Procedure cũ:
stock_quantity = stock_quantity + p_quantity

Nếu:
p_quantity = -500

=> Hệ thống sẽ:
cộng số âm

=> Thực chất là trừ kho.

=> Không có kiểm tra dữ liệu đầu vào.

========================================================
*/

DROP PROCEDURE IF EXISTS AddInventory;

DELIMITER //

CREATE PROCEDURE AddInventory
(
    IN p_item_id INT,
    IN p_quantity INT
)

BEGIN

    IF p_quantity <= 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'So luong nhap kho phai lon hon 0';

    ELSE

        UPDATE Inventory

        SET stock_quantity =
        stock_quantity + p_quantity

        WHERE item_id = p_item_id;

        IF ROW_COUNT() = 0 THEN

            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Khong tim thay vat tu';

        END IF;

    END IF;

END //

DELIMITER ;

SELECT *
FROM Inventory;

CALL AddInventory(10, 100);

CALL AddInventory(10, -500);

/*
========================================================
PHẦN B - GIẢI THÍCH LOGIC ĐÃ SỬA
========================================================

1. Kiểm tra dữ liệu đầu vào

IF p_quantity <= 0

=> Chặn:
    - số âm
    - số 0

=> Đúng quy tắc nhập kho.

========================================================

2. SIGNAL SQLSTATE

Dùng để báo lỗi nghiệp vụ.

Ví dụ:
'So luong nhap kho phai lon hon 0'

========================================================

3. ROW_COUNT()

Nếu:
UPDATE không tác động dòng nào

=> item_id không tồn tại

=> Báo lỗi:
'Khong tim thay vat tu'

========================================================

4. Kết quả cuối cùng

- Nhập số dương:
    cộng kho thành công

- Nhập số âm:
    bị chặn ngay lập tức

=> Tránh thất thoát vật tư

========================================================
*/