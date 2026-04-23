CREATE TABLE ORDERS (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100),
    OrderDate DATETIME,
    TotalAmount DECIMAL(18, 2),
    Status VARCHAR(20),         -- 'Completed', 'Canceled', 'Pending'
    
    -- Cờ soft delete (0 = còn dùng, 1 = đã xóa logic)
    IsDeleted TINYINT(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ============================================
-- 2. DỮ LIỆU MẪU
-- ============================================
INSERT INTO ORDERS (CustomerName, OrderDate, TotalAmount, Status) VALUES
('Nguyễn Văn A', '2023-01-10', 500000, 'Completed'),
('Khách hàng vãng lai', '2023-02-15', 1200000, 'Canceled'), -- "rác"
('Trần Thị B', '2023-05-20', 300000, 'Canceled'),          -- "rác"
('Lê Văn C', '2024-01-05', 850000, 'Completed');


-- ============================================
-- 3. CODE HIỆN TẠI (VẤN ĐỀ)
-- ============================================

SELECT * FROM ORDERS WHERE Status = 'Completed';

-- ❌ Vấn đề:
-- - Dữ liệu "Canceled" vẫn nằm trong bảng
-- - Query vẫn phải scan qua → chậm dần theo thời gian


-- ============================================
-- 4. GIẢI PHÁP 1: HARD DELETE
-- ============================================

-- Xóa thật dữ liệu bị hủy
DELETE FROM ORDERS
WHERE Status = 'Canceled';

-- ✔ Ưu:
-- - Giải phóng dung lượng
-- - Query nhanh hơn

-- ❌ Nhược:
-- - Mất dữ liệu vĩnh viễn
-- - Không đáp ứng kiểm toán (audit)


-- ============================================
-- 5. GIẢI PHÁP 2: SOFT DELETE (ĐƯỢC CHỌN)
-- ============================================

-- Đánh dấu đơn bị hủy là "đã xóa logic"
UPDATE ORDERS
SET IsDeleted = 1
WHERE Status = 'Canceled';

-- ✔ Không mất dữ liệu
-- ✔ Kế toán vẫn truy lại được


-- ============================================
-- 6. TRUY VẤN SAU KHI ÁP DỤNG SOFT DELETE
-- ============================================

-- ✔ Query cho hệ thống bán hàng (ẩn đơn hủy)
SELECT *
FROM ORDERS
WHERE IsDeleted = 0;

-- ✔ Query cho kế toán (vẫn thấy đơn hủy)
SELECT *
FROM ORDERS
WHERE Status = 'Canceled';


-- ============================================
-- 7. TỐI ƯU (QUAN TRỌNG)
-- ============================================

-- Tạo index để tránh scan toàn bảng
CREATE INDEX idx_orders_active 
ON ORDERS (IsDeleted, Status);


-- ============================================
-- 8. TÓM TẮT NGẮN GỌN
-- ============================================

-- Hard Delete:
-- ✔ Nhanh, nhẹ
-- ❌ Mất dữ liệu → không audit được

-- Soft Delete:
-- ✔ Giữ lịch sử (đúng nghiệp vụ kế toán)
-- ❌ Phải filter thêm IsDeleted

-- 👉 Chọn Soft Delete vì:
-- = cân bằng giữa hiệu năng + lưu trữ lịch sử