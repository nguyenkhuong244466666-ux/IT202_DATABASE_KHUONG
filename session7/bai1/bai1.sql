SELECT title, price
FROM Courses
WHERE price IN (
    SELECT price 
    FROM Courses 
    WHERE instructor_id = 5
);