/*Cột room_name không nằm trong GROUP BY và không dùng hàm tập hợp
 Một hotel_id nhóm nhiều room_name khác nhau, cơ sở dữ liệu không 
 thể xác định sẽ hiển thị room_name nào đại diện cho nhóm đó.*/
 
SELECT hotel_id, MIN(price_per_night) AS min_price
FROM Rooms
GROUP BY hotel_id;