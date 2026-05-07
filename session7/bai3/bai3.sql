/*
========================================================
BÀI TOÁN: TÌM "HỌC VIÊN NGỦ ĐÔNG"
========================================================

Yêu cầu:
- Lấy danh sách email học viên (Students)
- Những người CHƯA TỪNG thanh toán trong năm 2024

========================================================
PHÂN TÍCH KỸ THUẬT (Tech Lead)
========================================================

1. Vì sao KHÔNG dùng NOT IN?

- NOT IN sẽ:
  + Chạy subquery trước → lấy toàn bộ danh sách student_id đã mua
  + Load vào RAM
  + So sánh từng student với toàn bộ list

=> Với 5 triệu users:
   ❌ Tốn RAM lớn
   ❌ So sánh chậm
   ❌ Có bug nếu subquery trả về NULL

--------------------------------------------------------

2. Vì sao dùng NOT EXISTS tốt hơn?

- NOT EXISTS dùng Correlated Subquery (truy vấn tương quan)
- Với mỗi student:
    + DB đi tìm trong Payments
    + Nếu thấy 1 dòng khớp → DỪNG NGAY (short-circuit)
    + Không cần quét toàn bộ

=> Lợi ích:
   ✅ Giảm CPU
   ✅ Giảm RAM
   ✅ Nhanh hơn trên dataset lớn
   ✅ Không bị lỗi NULL

--------------------------------------------------------

3. Short-circuit là gì?

Ví dụ:
- Student A có thanh toán trong 2024
- DB chỉ cần tìm thấy 1 record → STOP luôn
- Không cần kiểm tra thêm

=> Đây là lý do NOT EXISTS tối ưu hơn NOT IN

========================================================
CÂU SQL CHUẨN (PRODUCTION READY)
========================================================
*/

SELECT s.email
FROM Students s
WHERE NOT EXISTS (
    SELECT 1
    FROM Payments p
    WHERE p.student_id = s.id
      -- kiểm tra thanh toán trong năm 2024
      -- KHÔNG dùng YEAR() để tránh mất index
      AND p.payment_date >= '2024-01-01'
      AND p.payment_date < '2025-01-01'
);

/*
========================================================
GIẢI THÍCH NGẮN GỌN
========================================================

- Với mỗi student:
    → kiểm tra có payment trong 2024 không

- Nếu KHÔNG tồn tại (NOT EXISTS)
    → giữ lại (học viên ngủ đông)

- Nếu tồn tại
    → loại bỏ

========================================================
KẾT LUẬN
========================================================

❗ Dataset lớn → luôn ưu tiên NOT EXISTS
❗ Tận dụng short-circuit để tối ưu performance
❗ Tránh NOT IN khi có thể
========================================================
*/