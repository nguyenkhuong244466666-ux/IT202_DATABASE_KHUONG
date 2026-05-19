CREATE DATABASE ontap;
USE ontap;

CREATE TABLE teams(
	te_id INT PRIMARY KEY AUTO_INCREMENT,
    te_name VARCHAR(100) NOT NULL,
    hq_country VARCHAR(50) NOT NULL,
    budget_cap DECIMAL(15,2) NOT NULL,
    current_rank INT DEFAULT 0
);

CREATE TABLE drivers(
	dri_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    dri_number INT NOT NULL UNIQUE,
    nationality VARCHAR(50) NOT NULL,
    annual_salary DECIMAL(12,2) NOT NULL,
    te_id INT,
    FOREIGN KEY (te_id) REFERENCES teams(te_id)
);

CREATE TABLE  constructors_championship(
	championship_id INT PRIMARY KEY AUTO_INCREMENT,
    season_year YEAR NOT NULL,
	te_id INT,
	total_points DECIMAL(5,1) DEFAULT 0.0,
    FOREIGN KEY(te_id) REFERENCES teams(te_id)
);

CREATE TABLE races(
    race_id INT PRIMARY KEY AUTO_INCREMENT,
    race_name VARCHAR(100) NOT NULL,
    circuit_name VARCHAR(100) NOT NULL,
    race_date DATETIME NOT NULL,
    race_status VARCHAR(30) DEFAULT 'Scheduled'
);

CREATE TABLE race_results(
    result_id INT PRIMARY KEY AUTO_INCREMENT,
    dri_id INT,
    race_id INT,
    grid_position INT NOT NULL,
    finish_position INT,
    points_earned DECIMAL(4,1) DEFAULT 0.0,
    fastest_lap_speed DECIMAL(5,2) DEFAULT 0.00,
    FOREIGN KEY (dri_id) REFERENCES drivers(dri_id),
    FOREIGN KEY (race_id) REFERENCES races(race_id)
);

INSERT INTO teams(te_name, hq_country, budget_cap, current_rank)
VALUES
('Red Bull Racing', 'Austria', 450000000.00, 1),
('Mercedes', 'Germany', 420000000.00, 2),
('Ferrari', 'Italy', 410000000.00, 3),
('McLaren', 'United Kingdom', 390000000.00, 4),
('Aston Martin', 'United Kingdom', 370000000.00, 5);

INSERT INTO drivers(full_name, dri_number, nationality, annual_salary, te_id)
VALUES
('Max Verstappen', 1, 'Dutch', 55000000.00, 1),
('Lewis Hamilton', 44, 'British', 45000000.00, 2),
('Charles Leclerc', 16, 'Monaco', 30000000.00, 3),
('Lando Norris', 4, 'British', 22000000.00, 4),
('Fernando Alonso', 14, 'Spanish', 18000000.00, 5);

INSERT INTO constructors_championship(season_year, te_id, total_points)
VALUES
(2026, 1, 320.5),
(2026, 2, 280.0),
(2026, 3, 250.5),
(2026, 4, 220.0),
(2026, 5, 180.5);

INSERT INTO races(race_name, circuit_name, race_date, race_status)
VALUES
('Bahrain GP', 'Bahrain International Circuit', '2026-03-10 18:00:00', 'Finished'),
('Monaco GP', 'Circuit de Monaco', '2026-05-25 20:00:00', 'Finished'),
('Silverstone GP', 'Silverstone Circuit', '2026-07-15 19:00:00', 'Finished'),
('Suzuka GP', 'Suzuka Circuit', '2026-09-20 17:00:00', 'Finished'),
('Monza GP', 'Autodromo Nazionale Monza', '2026-10-05 21:00:00', 'Scheduled');

INSERT INTO race_results(dri_id, race_id, grid_position, finish_position, points_earned, fastest_lap_speed)
VALUES
(1, 1, 1, 1, 25.0, 245.50),
(2, 1, 3, 2, 18.0, 242.30),
(3, 1, 2, 3, 15.0, 238.20),
(4, 2, 4, 1, 25.0, 241.80),
(5, 2, 5, NULL, 0.0, 230.00),

(1, 3, 1, 1, 25.0, 246.10),
(2, 3, 2, 4, 12.0, 239.50),
(3, 3, 3, 2, 18.0, 240.20),
(4, 4, 4, 21, 0.0, 228.00), 
(5, 4, 5, 5, 10.0, 235.40);


UPDATE drivers
SET annual_salary = annual_salary * 1.10
WHERE nationality = 'British'
AND dri_id IN (
    SELECT dri_id
    FROM race_results
    GROUP BY dri_id
    HAVING AVG(points_earned) > 15.0
);

DELETE FROM race_results
WHERE finish_position > 20;

-- PHẦN 3: TRUY VẤN CƠ BẢN

SELECT full_name, dri_number, nationality
FROM drivers
WHERE annual_salary > 20000000 OR nationality = 'Dutch';


SELECT te_name, hq_country
FROM teams
WHERE current_rank BETWEEN 1 AND 3
AND (
        hq_country LIKE 'M%'
     OR hq_country LIKE 'G%'
    );

SELECT race_id, race_name, race_date
FROM races
ORDER BY race_date DESC
LIMIT 2 OFFSET 2;

SELECT
    d.full_name,
    t.te_name,
    SUM(rr.points_earned) AS total_points,
    MAX(rr.fastest_lap_speed) AS max_fastest_lap_speed
FROM drivers d
JOIN teams t
    ON d.te_id = t.te_id
JOIN race_results rr
    ON d.dri_id = rr.dri_id
GROUP BY d.dri_id, d.full_name, t.te_name;


SELECT
    t.te_name,
    SUM(rr.points_earned) AS total_team_points
FROM teams t
JOIN drivers d
    ON t.te_id = d.te_id
JOIN race_results rr
    ON d.dri_id = rr.dri_id
GROUP BY t.te_id, t.te_name
HAVING SUM(rr.points_earned) > 50;


SELECT
    dri_id,
    full_name,
    annual_salary
FROM drivers
WHERE annual_salary = (
    SELECT MAX(annual_salary)
    FROM drivers
);



-- PHẦN 5: INDEX & VIEW

CREATE INDEX idx_driver_perf
ON race_results(finish_position, points_earned);


CREATE VIEW view_team_financials AS
SELECT
    t.te_name,
    COUNT(d.dri_id) AS total_drivers,
    SUM(d.annual_salary) AS total_salary
FROM teams t
LEFT JOIN drivers d
    ON t.te_id = d.te_id
WHERE d.annual_salary > 0
GROUP BY t.te_id, t.te_name;



-- PHẦN 6: TRIGGER

DELIMITER //

CREATE TRIGGER tg_bonus_salary
AFTER INSERT
ON race_results
FOR EACH ROW
BEGIN
    IF NEW.points_earned > 25 THEN
        UPDATE drivers
        SET annual_salary = annual_salary + 50000
        WHERE dri_id = NEW.dri_id;
    END IF;
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER tg_update_constructor_points
AFTER UPDATE
ON races
FOR EACH ROW
BEGIN
    DECLARE v_team_id INT;

    IF NEW.race_status = 'Finished'
    AND OLD.race_status <> 'Finished' THEN

        SELECT d.te_id
        INTO v_team_id
        FROM race_results rr
        JOIN drivers d
            ON rr.dri_id = d.dri_id
        WHERE rr.race_id = NEW.race_id
        AND rr.finish_position = 1
        LIMIT 1;

        UPDATE constructors_championship
        SET total_points = total_points + 10
        WHERE te_id = v_team_id;
    END IF;
END //

DELIMITER ;



-- PHẦN 7: STORED PROCEDURE

DELIMITER //

CREATE PROCEDURE proc_evaluate_driver(
    IN p_driver_id INT
)
BEGIN
    DECLARE v_total_points DECIMAL(10,2);

    SELECT SUM(points_earned)
    INTO v_total_points
    FROM race_results
    WHERE dri_id = p_driver_id;

    IF v_total_points > 100 THEN
        SELECT 'World Champion Class' AS evaluation;

    ELSEIF v_total_points BETWEEN 50 AND 100 THEN
        SELECT 'Podium Contender' AS evaluation;

    ELSE
        SELECT 'Midfield Driver' AS evaluation;
    END IF;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE proc_transfer_driver(
    IN p_driver_id INT,
    IN p_new_team_id INT
)
BEGIN
    DECLARE v_old_team_id INT;
    DECLARE v_total_salary DECIMAL(15,2);
    DECLARE v_budget_cap DECIMAL(15,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    CREATE TABLE IF NOT EXISTS driver_transfer_history(
        transfer_id INT PRIMARY KEY AUTO_INCREMENT,
        driver_id INT,
        old_team_id INT,
        new_team_id INT,
        transfer_date DATETIME DEFAULT CURRENT_TIMESTAMP
    );

    SELECT te_id
    INTO v_old_team_id
    FROM drivers
    WHERE dri_id = p_driver_id;

    UPDATE drivers
    SET te_id = p_new_team_id
    WHERE dri_id = p_driver_id;

    INSERT INTO driver_transfer_history(
        driver_id,
        old_team_id,
        new_team_id
    )
    VALUES(
        p_driver_id,
        v_old_team_id,
        p_new_team_id
    );

    SELECT SUM(annual_salary)
    INTO v_total_salary
    FROM drivers
    WHERE te_id = p_new_team_id;

    SELECT budget_cap
    INTO v_budget_cap
    FROM teams
    WHERE te_id = p_new_team_id;

    IF v_total_salary > v_budget_cap THEN
        ROLLBACK;

    ELSE
        COMMIT;
    END IF;
END //

DELIMITER ;



-- TEST PROCEDURE

CALL proc_evaluate_driver(1);

CALL proc_transfer_driver(5,1);


-- TEST TRIGGER

INSERT INTO race_results(dri_id, race_id, grid_position, finish_position, points_earned, fastest_lap_speed)
VALUES
(1,5,1,1,26.0,247.50);


UPDATE races
SET race_status = 'Finished'
WHERE race_id = 5;



-- KIỂM TRA DỮ LIỆU

SELECT *
FROM drivers;

SELECT *
FROM constructors_championship;

SELECT *
FROM driver_transfer_history;

SELECT *
FROM view_team_financials;

