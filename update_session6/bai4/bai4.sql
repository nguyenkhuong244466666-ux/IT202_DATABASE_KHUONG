SELECT 
    hotel_id
FROM 
    Orders
WHERE 
    status = 'COMPLETED'
GROUP BY 
    hotel_id
HAVING 
    COUNT(order_id) >= 50 
    AND AVG(total_price) > 3000000;