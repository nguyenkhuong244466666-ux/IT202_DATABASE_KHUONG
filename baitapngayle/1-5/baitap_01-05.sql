USE cine_magic;

INSERT INTO movies
VALUES(1, 'Avengers: Secret Wars', 150, 13),
	  (2, 'Fast & Furious 11', 140, 16),
	  (3, 'The Nun 3', 110, 18),
	  (4, 'Doraemon Movie', 100, 0);
      
INSERT INTO rooms
VALUES(1, 'Room A', 100, 'active'),
	  (2, 'Room B', 80, 'maintenance'),
	  (3, 'Room C', 120, 'active');
      
INSERT INTO showtimes
VALUES(1, 1, 1, '2026-05-01 18:00:00', 90000),
	  (2, 2, 3, '2026-05-01 20:00:00', 100000),
	  (3, 3, 1, '2026-05-01 22:00:00', 110000),
	  (4, 4, 3, '2026-05-02 17:00:00', 80000),
	  (5, 1, 1, '2026-05-02 19:00:00', 95000);
      
INSERT INTO bookings
VALUES(1, 1, 'Nguyen Van A', '0901111111', NULL),
	  (2, 1, 'Tran Thi B', '0902222222', NULL),
	  (3, 2, 'Le Van C', '0903333333', NULL),
	  (4, 2, 'Pham Thi D', '0904444444', NULL),
	  (5, 3, 'Hoang Van E', '0905555555', NULL),
	  (6, 3, 'Do Thi F', '0906666666', NULL),
	  (7, 4, 'Nguyen Van G', '0907777777', NULL),
	  (8, 4, 'Tran Thi H', '0908888888', NULL),
	  (9, 5, 'Le Van I', '0909999999', NULL),
	  (10, 5, 'Pham Thi K', '0910000000', NULL);

