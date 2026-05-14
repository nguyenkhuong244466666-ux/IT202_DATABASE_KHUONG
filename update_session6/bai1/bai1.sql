-- WHERE thực thi trước GROUP BY nên không thể dùng hàm tập hợp SUM(). Phải dùng HAVING.
SELECT city, SUM(total_price) AS revenue
FROM Bookings
WHERE status = 'COMPLETED'
GROUP BY city
HAVING SUM(total_price) > 0;