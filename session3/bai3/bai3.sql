-- 1. TẠO BẢNG CUSTOMERS
-- ============================================
CREATE TABLE CUSTOMERS (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(50),
    LastPurchaseDate DATE,      -- Ngày mua cuối
    Status VARCHAR(20),         -- Active / Locked
    Gender VARCHAR(10),
    DateOfBirth DATE,
    Points INT,
    Address VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ============================================
-- 2. DỮ LIỆU MẪU (CÓ BẪY)
-- ============================================
INSERT INTO CUSTOMERS (FullName, Email, City, LastPurchaseDate, Status) VALUES
('Nguyễn Văn A', 'anv@gmail.com', 'Hà Nội', '2025-05-20', 'Active'),   -- >6 tháng ✔
('Trần Thị B', 'btt@gmail.com', 'Hà Nội', '2026-02-10', 'Active'),     -- Mới mua ❌
('Lê Văn C', NULL, 'Hà Nội', '2025-01-15', 'Active'),                  -- NULL email ❌
('Phạm Minh D', 'dpm@gmail.com', 'Hà Nội', '2024-12-01', 'Locked'),    -- Locked ❌
('Hoàng An E', 'eha@gmail.com', 'TP HCM', '2025-03-01', 'Active');     -- Sai city ❌


-- ============================================
-- 3. CODE SAI (ANTI-PATTERN)
-- ============================================

SELECT * 
FROM CUSTOMERS;

-- ❌ Sai:
-- - Lấy toàn bộ cột (dư thừa)
-- - Không filter → sai nghiệp vụ
-- - Gây chậm hệ thống


-- ============================================
-- 4. CODE ĐÚNG (THEO NGHIỆP VỤ)
-- ============================================

SELECT 
    FullName,      -- chỉ lấy cột cần
    Email
FROM CUSTOMERS
WHERE 
    City = 'Hà Nội'                      -- đúng khu vực
    AND LastPurchaseDate < '2025-10-01'  -- >6 tháng (tính từ 01/04/2026)
    AND Status = 'Active'                -- chỉ user hoạt động
    AND Email IS NOT NULL                -- tránh NULL
    AND Email <> '';                     -- tránh email rỗng


-- ============================================
-- 5. PHÂN TÍCH NGẮN GỌN
-- ============================================

-- Lỗi chính:
-- 1. Dùng SELECT * → dư dữ liệu, chậm
-- 2. Không lọc:
--    - Lấy cả user mới mua
--    - Lấy user bị khóa
--    - Lấy user không có email → hệ thống gửi mail crash

-- Sửa:
-- ✔ Chỉ select cần thiết
-- ✔ Filter đúng nghiệp vụ
-- ✔ Loại bỏ data bẩn (NULL, Locked)