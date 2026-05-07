/*
========================================================
KHÁM NGHIỆM LỖI NOT IN + NULL (BOOLEAN LOGIC)
========================================================

Query lỗi:
SELECT * FROM Courses
WHERE id NOT IN (SELECT course_id FROM Enrollments);

----------------------------------------

Giả sử subquery trả về:
(1, 2, NULL)

→ Câu điều kiện trở thành:

id NOT IN (1, 2, NULL)

----------------------------------------

Phân tích theo logic:

NOT IN = phủ định của IN

id IN (1, 2, NULL)
= (id = 1 OR id = 2 OR id = NULL)

----------------------------------------

Vấn đề nằm ở:

id = NULL  → KHÔNG phải TRUE / FALSE
            → mà là UNKNOWN (trong SQL)

----------------------------------------

=> Toàn bộ biểu thức:

(id = 1 OR id = 2 OR id = NULL)

→ nếu không match 1 hoặc 2
→ sẽ còn lại (FALSE OR FALSE OR UNKNOWN)
→ = UNKNOWN

----------------------------------------

NOT IN (UNKNOWN) → vẫn là UNKNOWN

👉 Trong WHERE:
- TRUE → lấy
- FALSE → bỏ
- UNKNOWN → cũng bị bỏ ❌

=> KẾT QUẢ: KHÔNG TRẢ VỀ DÒNG NÀO

========================================================
GIẢI PHÁP 1: VÁ NULL TRONG SUBQUERY
========================================================

- Loại bỏ NULL ngay từ đầu

*/

SELECT *
FROM Courses
WHERE id NOT IN (
    SELECT course_id
    FROM Enrollments
    WHERE course_id IS NOT NULL
);

/*
========================================================
GIẢI PHÁP 2 (KHUYẾN NGHỊ): DÙNG NOT EXISTS
========================================================

- Không bị ảnh hưởng bởi NULL
- Tối ưu hơn
- Có short-circuit

*/

SELECT *
FROM Courses c
WHERE NOT EXISTS (
    SELECT 1
    FROM Enrollments e
    WHERE e.course_id = c.id
);

/*
========================================================
KẾT LUẬN
========================================================

❗ NOT IN + NULL → cực kỳ nguy hiểm
❗ Luôn filter NULL trong subquery
   HOẶC dùng NOT EXISTS (an toàn tuyệt đối)

========================================================
*/