CREATE DATABASE social_network;
USE social_network;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    like_count INT DEFAULT 0,
    comment_count INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB;

CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB;

CREATE TABLE likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (post_id) REFERENCES posts(post_id)
) ENGINE=InnoDB;

CREATE TABLE friends (
    friendship_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    smaller_id INT AS (LEAST(user_id, friend_id)) STORED,
    bigger_id INT AS (GREATEST(user_id, friend_id)) STORED,
    CHECK (status IN ('pending','accepted')),
    CHECK (user_id <> friend_id),
    UNIQUE(smaller_id, bigger_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (friend_id) REFERENCES users(user_id)
) ENGINE=InnoDB;

CREATE FULLTEXT INDEX idx_post_content
ON posts(content);

INSERT INTO users(username,password,email) VALUES
('an123','123456','an@gmail.com'),
('binh456','123456','binh@gmail.com'),
('cuong789','123456','cuong@gmail.com');

INSERT INTO posts(user_id,content) VALUES
(1,'Hello everyone'),
(2,'Learning mysql trigger'),
(3,'Mini social network project');

INSERT INTO comments(post_id,user_id,content) VALUES
(1,2,'Nice post'),
(1,3,'Very good'),
(2,1,'Excellent');

INSERT INTO likes(user_id,post_id) VALUES
(1,2),
(2,1),
(3,1);

INSERT INTO friends(user_id,friend_id,status) VALUES
(1,2,'accepted'),
(2,3,'pending');

CREATE VIEW view_user_info AS
SELECT
    user_id,
    username,
    email,
    created_at
FROM users;

DELIMITER //

CREATE PROCEDURE sp_add_user(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_email VARCHAR(100)
)
BEGIN
    IF EXISTS (
        SELECT 1
        FROM users
        WHERE username = p_username
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username already exists';

    ELSEIF EXISTS (
        SELECT 1
        FROM users
        WHERE email = p_email
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email already exists';

    ELSE
        INSERT INTO users(username,password,email)
        VALUES(p_username,p_password,p_email);
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE sp_add_post(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    INSERT INTO posts(user_id,content)
    VALUES(p_user_id,p_content);
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER tg_after_like_insert
AFTER INSERT
ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER tg_after_like_delete
AFTER DELETE
ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count =
        CASE
            WHEN like_count > 0 THEN like_count - 1
            ELSE 0
        END
    WHERE post_id = OLD.post_id;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER tg_after_comment_insert
AFTER INSERT
ON comments
FOR EACH ROW
BEGIN
    UPDATE posts
    SET comment_count = comment_count + 1
    WHERE post_id = NEW.post_id;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER tg_after_comment_delete
AFTER DELETE
ON comments
FOR EACH ROW
BEGIN
    UPDATE posts
    SET comment_count =
        CASE
            WHEN comment_count > 0 THEN comment_count - 1
            ELSE 0
        END
    WHERE post_id = OLD.post_id;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE sp_user_activity_report()
BEGIN
    SELECT
        u.user_id,
        u.username,
        COUNT(DISTINCT p.post_id) AS total_posts,
        COUNT(DISTINCT l.like_id) AS total_likes,
        COUNT(DISTINCT c.comment_id) AS total_comments
    FROM users u
    LEFT JOIN posts p
        ON u.user_id = p.user_id
    LEFT JOIN likes l
        ON p.post_id = l.post_id
    LEFT JOIN comments c
        ON p.post_id = c.post_id
    GROUP BY u.user_id, u.username;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE sp_accept_friend(
    IN p_user_id INT,
    IN p_friend_id INT
)
BEGIN
    UPDATE friends
    SET status = 'accepted'
    WHERE user_id = p_user_id
      AND friend_id = p_friend_id;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE sp_friend_suggestion(
    IN p_user_id INT
)
BEGIN
    WITH mutual_friends AS (
        SELECT
            f2.friend_id AS suggested_friend,
            COUNT(*) AS mutual_count
        FROM friends f1
        JOIN friends f2
            ON f1.friend_id = f2.user_id
        WHERE f1.user_id = p_user_id
          AND f2.friend_id <> p_user_id
        GROUP BY f2.friend_id
    )
    SELECT
        u.user_id,
        u.username,
        mf.mutual_count
    FROM mutual_friends mf
    JOIN users u
        ON mf.suggested_friend = u.user_id;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE sp_delete_user(
    IN p_user_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM likes
    WHERE user_id = p_user_id
       OR post_id IN (
            SELECT temp.post_id
            FROM (
                SELECT post_id
                FROM posts
                WHERE user_id = p_user_id
            ) temp
       );

    DELETE FROM comments
    WHERE user_id = p_user_id
       OR post_id IN (
            SELECT temp.post_id
            FROM (
                SELECT post_id
                FROM posts
                WHERE user_id = p_user_id
            ) temp
       );

    DELETE FROM friends
    WHERE user_id = p_user_id
       OR friend_id = p_user_id;

    DELETE FROM posts
    WHERE user_id = p_user_id;

    DELETE FROM users
    WHERE user_id = p_user_id;

    COMMIT;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER tg_before_friend_insert
BEFORE INSERT
ON friends
FOR EACH ROW
BEGIN
    IF NEW.user_id = NEW.friend_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot add yourself as friend';

    ELSEIF EXISTS (
        SELECT 1
        FROM friends
        WHERE user_id = NEW.user_id
          AND friend_id = NEW.friend_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Friend request already exists';

    ELSEIF EXISTS (
        SELECT 1
        FROM friends
        WHERE user_id = NEW.friend_id
          AND friend_id = NEW.user_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reverse friend request already exists';
    END IF;
END //

DELIMITER ;

CALL sp_add_user(
    'david999',
    '123456',
    'david@gmail.com'
);

CALL sp_add_post(
    1,
    'New post from user 1'
);

CALL sp_user_activity_report();

CALL sp_accept_friend(2,3);

CALL sp_friend_suggestion(1);

INSERT INTO likes(user_id,post_id)
VALUES(1,1);

DELETE FROM likes
WHERE like_id = 1;

INSERT INTO comments(post_id,user_id,content)
VALUES(2,3,'Amazing');

DELETE FROM comments
WHERE comment_id = 1;

INSERT INTO friends(user_id,friend_id,status)
VALUES(1,1,'pending');

INSERT INTO friends(user_id,friend_id,status)
VALUES(2,1,'pending');

CALL sp_delete_user(3);

SELECT *
FROM view_user_info;

SELECT *
FROM posts
WHERE MATCH(content)
AGAINST('mysql');

SELECT *
FROM posts;

SELECT *
FROM likes;

SELECT *
FROM comments;

SELECT *
FROM friends;