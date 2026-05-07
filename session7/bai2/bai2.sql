/*
========================================
GIẢI THÍCH LÝ THUYẾT
========================================

1. Derived Table (Bảng dẫn xuất) là gì?
- Là một bảng tạm thời được tạo ra từ một câu SELECT con
- Xuất hiện trong mệnh đề FROM
- Ví dụ:
    (SELECT user_id, SUM(price) FROM Orders GROUP BY user_id)

=> Nó hoạt động như một "bảng ảo" để query tiếp

----------------------------------------

2. Tại sao bắt buộc phải có ALIAS?

- SQL Engine cần đặt tên cho bảng tạm này để:
  + Tham chiếu cột (SELECT, WHERE, JOIN...)
  + Phân biệt với các bảng khác
- Không có alias => DB không biết gọi bảng này là gì

=> Vì vậy MySQL báo lỗi:
"Every derived table must have its own alias"

----------------------------------------

3. Bài toán:
- Tính tổng tiền hệ thống thu được từ user VIP
- VIP = user có tổng chi tiêu > 10.000.000

=> Cách làm:
Bước 1: GROUP BY user_id để tính tổng chi tiêu từng người
Bước 2: Lọc ra user VIP
Bước 3: SUM lại toàn bộ tiền của nhóm VIP

========================================
CÂU SQL HOÀN CHỈNH
========================================
*/

SELECT SUM(total_spent) AS total_revenue_from_vip
FROM (
    SELECT user_id, SUM(price) AS total_spent
    FROM Orders
    GROUP BY user_id
    HAVING SUM(price) > 10000000
) AS vip_users;

/*
========================================
GIẢI THÍCH NGẮN GỌN
========================================

- Query con:
    → Tính tổng tiền từng user
    → Lọc user VIP

- Query ngoài:
    → Cộng toàn bộ tiền của các VIP

- "AS vip_users" là alias bắt buộc
========================================
*/