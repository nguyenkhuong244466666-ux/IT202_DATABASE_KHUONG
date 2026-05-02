USE cine_magi;

UPDATE rooms
SET status = 'maintenance'
WHERE id = 1;

UPDATE showtimes
SET room_id = 2
WHERE room_id = 1;

DELETE FROM bookings
WHERE phone = '0987654321';

DELETE FROM bookings
WHERE showtime_id IN (
    SELECT id FROM showtimes WHERE movie_id = 3
);

DELETE FROM showtimes
WHERE movie_id = 3;

DELETE FROM movies
WHERE id = 3;