/*Thiết kế I/O & Luồng
Sử dụng CASE WHEN bên trong hàm SUM()Gán giá trị 1 cho các đơn 
CANCELLED và 0 cho các đơn khác. Khi đó, SUM() sẽ chỉ cộng dồn các 
giá trị 1, tương đương với việc đếm số đơn hủy.*/

SELECT user_id
FROM Bookings
GROUP BY user_id
HAVING COUNT(user_id) >= 10 AND SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END) > 5;