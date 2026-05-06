-- Hướng 1 – Lọc trễ (Bad Practice)
SELECT hotel_id
FROM Bookings
GROUP BY hotel_id
HAVING 
    SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END) >= 50
AND AVG(CASE 
        WHEN status = 'COMPLETED' THEN total_price 
        ELSE NULL 
    END) > 3000000;
/* 
Vấn đề:
Gom toàn bộ dữ liệu (cả FAILED, CANCELLED…)
Sau đó mới lọc bằng HAVING
Tốn tài nguyên cực lớn */

-- Hướng 2 – Lọc sớm (Clean Code & Tối ưu)
SELECT hotel_id
FROM Bookings
WHERE status = 'COMPLETED'
GROUP BY hotel_id
HAVING COUNT(*) >= 50
AND AVG(total_price) > 3000000;