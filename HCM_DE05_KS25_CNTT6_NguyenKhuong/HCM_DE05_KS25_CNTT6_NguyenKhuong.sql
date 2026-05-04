CREATE DATABASE ESportsManagement;
USE ESportsManagement;

CREATE TABLE team(
	te_id VARCHAR(10) PRIMARY KEY,
    te_name VARCHAR(150) NOT NULL UNIQUE,
    nation VARCHAR(100) NOT NULL,
    te_owner VARCHAR(100),
    year_oe YEAR NOT NULL
);

CREATE TABLE player(
	p_id VARCHAR(10) PRIMARY KEY,
    p_name VARCHAR(150) NOT NULL UNIQUE,
    nickname VARCHAR(150) NOT NULL UNIQUE,
    playing_position VARCHAR(150) NOT NULL,
    P_wage DECIMAL(10,2) CHECK(p_wage>0),
    te_id VARCHAR(10),
	FOREIGN KEY(te_id) REFERENCES team(te_id)
);

CREATE TABLE _match(
	m_id  VARCHAR(10) PRIMARY KEY,
    star_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    result VARCHAR(100) NOT NULL
);

CREATE TABLE match_statistic(
	m_id VARCHAR(10),
    p_id VARCHAR(10),
    kills INT NOT NULL CHECK(kills>0),
    deaths INT NOT NULL CHECK(deaths>0),
    assists INT NOT NULL CHECK(assists>0),
    PRIMARY KEY(m_id,p_id),
    FOREIGN KEY(m_id) REFERENCES _match(m_id),
    FOREIGN KEY(p_id) REFERENCES player(p_id)
);

ALTER TABLE _match 
ADD prize DECIMAL(20,2);

ALTER TABLE team
RENAME COLUMN nation to khuvuc;

DROP TABLE match_statistic;
DROP TABLE _match;

INSERT INTO team
VALUES 
('team01','abc','long an','khuong',2026),
('team02','abcd','TP HCM','A',2020),
('team03','abdg','Ha Noi',NULL,2023),
('team04','abjhsd','TP HCM','DU',2024),
('team05','abcyen','long an',NULL,2026);

INSERT INTO player
VALUES 
('p001','nguyen a','abcgf','top','40000000','team01'),
('p002','nguyen b','abc','bot','10000000','team04'),
('p003','nguyen c','abcdg','mid','20000000','team02'),
('p004','nguyen d','hegf','top','30000000','team02'),
('p005','nguyen e','abshd','rung','5000000','team01');

INSERT INTO _match
VALUES 
('m001','2026-01-02','2-0',10000000),
('m002','2026-01-03','2-1',8000000),
('m003','2026-01-04','0-2',5000000),
('m004','2026-01-05','2-1',8000000),
('m005','2026-01-06','2-0',10000000);

UPDATE player
SET p_wage=p_wage * 1.2
WHERE playing_position='rung';

DELETE FROM team
WHERE  te_owner is NULL;

SELECT *
FROM player
WHERE p_wage >= 50000000 AND p_wage <= 150000000;










