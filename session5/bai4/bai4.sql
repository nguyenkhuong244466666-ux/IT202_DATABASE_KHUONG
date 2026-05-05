-- Giải pháp 1: dùng nhiều OR
SELECT *
FROM Orders
WHERE status = 'FAILED'
AND (
    reason = 'KHACH_HUY'
    OR reason = 'QUAN_DONG_CUA'
    OR reason = 'KHONG_CO_TAI_XE'
    OR reason = 'BOM_HANG'
);

-- Giải pháp 2: dùng IN
SELECT *
FROM Orders
WHERE status = 'FAILED'
AND reason IN ('KHACH_HUY', 'QUAN_DONG_CUA', 'KHONG_CO_TAI_XE', 'BOM_HANG');