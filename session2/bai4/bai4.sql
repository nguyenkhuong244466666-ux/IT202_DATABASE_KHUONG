CREATE DATABASE session2_bai4;
USE session2_bai4;


CREATE TABLE users (
    contactid INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    phone INT
);

/*
 * =============================================================================
 * PHÂN TÍCH GIẢI PHÁP THAY ĐỔI KIỂU DỮ LIỆU CỘT PHONE (2 TRIỆU BẢN GHI)
 * =============================================================================
 * * GIẢI PHÁP A: Trực tiếp (In-place Alteration)
 * - Lệnh: ALTER TABLE users MODIFY COLUMN phone VARCHAR(15);
 * * GIẢI PHÁP B: An toàn (Shadow Column / Copy & Swap)
 * - Quy trình: Thêm cột mới -> Copy dữ liệu -> Xóa cột cũ -> Đổi tên cột mới.
 *
 * -----------------------------------------------------------------------------
 * BẢNG SO SÁNH & LỰA CHỌN
 * -----------------------------------------------------------------------------
 * | Tiêu chí            | Giải pháp A (Sửa trực tiếp) | Giải pháp B (Cột tạm & Swap) |
 * |---------------------|---------------------------|-----------------------------|
 * | Rủi ro vận hành     | Cực cao (Khóa bảng lâu)    | Thấp (Ghi bình thường)      |
 * | Độ an toàn dữ liệu  | Dễ mất dữ liệu nếu lỗi     | An toàn, dễ kiểm tra        |
 * | Độ phức tạp         | Đơn giản (1 dòng code)     | Phức tạp hơn (nhiều bước)   |
 * | Thời gian Downtime  | Rất lâu (Tùy ổ cứng)       | Gần như bằng 0 (Zero)       |
 * -----------------------------------------------------------------------------
 *
 * ==> LỰA CHỌN: GIẢI PHÁP B (Đảm bảo tính sẵn sàng của hệ thống).
 * =============================================================================
 */

-- Tạo cột mới với kiểu dữ liệu chuẩn VARCHAR(15)
ALTER TABLE users ADD COLUMN phone_new VARCHAR(15);

-- Chuyển đổi dữ liệu từ cột cũ (INT) sang cột mới (VARCHAR)
-- LPAD giúp bù lại số 0 ở đầu bị mất (ví dụ: 987654321 -> 0987654321)
UPDATE users 
SET phone_new = LPAD(CAST(phone AS CHAR), 10, '0') 
WHERE phone IS NOT NULL;

-- Xóa cột dữ liệu cũ (kiểu INT không còn sử dụng)
ALTER TABLE users DROP COLUMN phone;

-- Đổi tên cột mới 'phone_new' thành 'phone' để khớp với code ứng dụng
ALTER TABLE users CHANGE COLUMN phone_new phone VARCHAR(15) NOT NULL;

-- Thêm ràng buộc UNIQUE để đảm bảo không trùng số điện thoại
ALTER TABLE users ADD CONSTRAINT UC_Phone UNIQUE (phone);
