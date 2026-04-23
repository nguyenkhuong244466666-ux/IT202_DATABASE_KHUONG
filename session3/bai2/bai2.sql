-- ============================================
-- 1. TẠO BẢNG SHIPPERS
-- ============================================
CREATE TABLE SHIPPERS (
    ShipperID INT PRIMARY KEY AUTO_INCREMENT, -- ID tự tăng
    ShipperName VARCHAR(255),                 -- Tên đơn vị vận chuyển
    Phone VARCHAR(20)                         -- Số điện thoại
);

-- ============================================
-- 2. LỖI 1: SYNTAX ERROR (LỖI CÚ PHÁP)
-- ============================================

-- ❌ CODE SAI
INSERT INTO SHIPPERS (ShipperName, Phone)
VALUES ('Giao Hàng Nhanh, '0901234567');

-- ❌ PHÂN TÍCH:
-- - Thiếu dấu nháy đơn đóng sau chuỗi 'Giao Hàng Nhanh'
-- - SQL hiểu sai chuỗi:
--     'Giao Hàng Nhanh, '0901234567'
-- - Dẫn đến lỗi cú pháp (Syntax Error)

-- ✅ CODE ĐÚNG
INSERT INTO SHIPPERS (ShipperName, Phone)
VALUES ('Giao Hàng Nhanh', '0901234567');


-- ============================================
-- 3. LỖI 2: KHÔNG BÁO LỖI NHƯNG DỮ LIỆU BỊ NULL
-- ============================================

-- ❌ CODE SAI
INSERT INTO SHIPPERS
VALUES ('Viettel Post');

-- ❌ PHÂN TÍCH:
-- - Không chỉ định danh sách cột (column list)
-- - Bảng có 3 cột:
--     (ShipperID, ShipperName, Phone)
-- - Nhưng chỉ truyền 1 giá trị → SQL sẽ map theo thứ tự:
--     ShipperID = 'Viettel Post' ❌ (sai kiểu dữ liệu)
--     hoặc (tuỳ hệ DB):
--         ShipperName = 'Viettel Post'
--         Phone = NULL ❌

-- 👉 Nguyên nhân chính:
-- - Không chỉ rõ cột → dễ lệch dữ liệu
-- - Phone không được truyền → bị NULL

-- ✅ CODE ĐÚNG (cách 1 - rõ ràng nhất)
INSERT INTO SHIPPERS (ShipperName, Phone)
VALUES ('Viettel Post', '0987654321');


-- ✅ CODE ĐÚNG (cách 2 - nếu chưa có số điện thoại)
INSERT INTO SHIPPERS (ShipperName, Phone)
VALUES ('Viettel Post', NULL);


-- ============================================
-- 4. BEST PRACTICE (TRÁNH BUG NGẦM)
-- ============================================

-- ✔ LUÔN chỉ định tên cột khi INSERT
-- ❌ Tránh viết kiểu:
-- INSERT INTO SHIPPERS VALUES (...)

-- ✔ Validate dữ liệu đầu vào (tránh thiếu Phone)

-- ✔ Có thể ép NOT NULL để tránh dữ liệu rác
-- ALTER TABLE SHIPPERS MODIFY Phone VARCHAR(20) NOT NULL;


-- ============================================
-- 5. TÓM TẮT 2 LỖI CHÍNH
-- ============================================

-- Lỗi 1: Thiếu dấu nháy → Syntax Error → không chạy được
-- Lỗi 2: Không chỉ định cột → dữ liệu bị lệch → Phone = NULL

-- 👉 Đây là kiểu lỗi:
-- - Một cái "fail ngay lập tức" (dễ phát hiện)
-- - Một cái "fail âm thầm" (nguy hiểm hơn trong thực tế)