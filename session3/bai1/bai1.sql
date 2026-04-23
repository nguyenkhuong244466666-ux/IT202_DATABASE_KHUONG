-- ============================================
-- 1. TẠO BẢNG SẢN PHẨM
-- ============================================
CREATE TABLE PRODUCTS (
    ProductID INT PRIMARY KEY,          -- Mã sản phẩm (duy nhất)
    ProductName VARCHAR(100),           -- Tên sản phẩm
    Category VARCHAR(50),               -- Ngành hàng (Electronics, Food,...)
    OriginalPrice DECIMAL(18,2)         -- Giá gốc
);

-- ============================================
-- 2. CHÈN DỮ LIỆU MẪU
-- ============================================
INSERT INTO PRODUCTS (ProductID, ProductName, Category, OriginalPrice)
VALUES
(1, 'iPhone 15', 'Electronics', 20000000),
(2, 'Samsung Refrigerator', 'Electronics', 15000000),
(3, 'Water Spinach', 'Food', 10000),
(4, 'Filtered Fresh Milk 4', 'Food', 28000);

-- ============================================
-- 3. CODE SAI (GÂY LỖI NGHIÊM TRỌNG)
-- ============================================
-- Mục tiêu: giảm 10% cho Electronics
-- Nhưng thực tế: giảm 10% cho TẤT CẢ sản phẩm

UPDATE PRODUCTS
SET OriginalPrice = OriginalPrice * 0.9;

-- ❌ PHÂN TÍCH LỖI:
-- - Thiếu mệnh đề WHERE
-- - SQL hiểu rằng: áp dụng cho toàn bộ bảng
-- - Kết quả:
--     Electronics ✔ bị giảm (đúng)
--     Food ❌ cũng bị giảm (sai nghiệp vụ)
-- - Đây là lỗi cực kỳ nguy hiểm trong production


-- ============================================
-- 4. CÁCH LÀM ĐÚNG NGHIỆP VỤ
-- ============================================

UPDATE PRODUCTS
SET OriginalPrice = OriginalPrice * 0.9
WHERE Category = 'Electronics';

-- ✅ GIẢI THÍCH:
-- - WHERE Category = 'Electronics'
--   ⇒ chỉ chọn đúng nhóm cần giảm giá
-- - Các sản phẩm Food sẽ KHÔNG bị ảnh hưởng


-- ============================================
-- 5. BEST PRACTICE (TRÁNH "TOANG" DATA)
-- ============================================

-- ✔ 1. Luôn kiểm tra trước bằng SELECT
SELECT * 
FROM PRODUCTS
WHERE Category = 'Electronics';

-- ✔ 2. Dùng TRANSACTION để có thể rollback nếu sai
BEGIN TRANSACTION;

UPDATE PRODUCTS
SET OriginalPrice = OriginalPrice * 0.9
WHERE Category = 'Electronics';

-- Kiểm tra lại kết quả
SELECT * FROM PRODUCTS;

-- Nếu đúng → COMMIT
-- COMMIT;

-- Nếu sai → ROLLBACK
-- ROLLBACK;


-- ✔ 3. Có thể thêm điều kiện bảo vệ (defensive coding)
-- Ví dụ: chỉ giảm nếu giá > 0

UPDATE PRODUCTS
SET OriginalPrice = OriginalPrice * 0.9
WHERE Category = 'Electronics'
  AND OriginalPrice > 0;