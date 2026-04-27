USE book_worm;

SELECT *
FROM books
WHERE category = 'Trinh tham'
  AND price < 100000;

SELECT *
FROM customers
WHERE email LIKE '%@gmail.com';

SELECT *
FROM books
ORDER BY price DESC
LIMIT 3;

UPDATE books
SET price = price * 0.9
WHERE publish_year < 2020;