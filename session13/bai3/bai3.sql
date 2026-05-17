USE RikkeiClinicDB;

CREATE TABLE Price_Changes_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_id INT,
    old_price DECIMAL(18,2),
    new_price DECIMAL(18,2),
    change_type VARCHAR(20),
    difference_amount DECIMAL(18,2),
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (medicine_id) REFERENCES Medicines(medicine_id)
);

DROP TRIGGER IF EXISTS trg_MedicinePriceAudit;

DELIMITER //

CREATE TRIGGER trg_MedicinePriceAudit
BEFORE UPDATE ON Medicines
FOR EACH ROW
BEGIN

    IF NEW.price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Giá thuốc mới không hợp lệ';
    END IF;

    IF OLD.price <> NEW.price THEN

        IF NEW.price > OLD.price THEN

            INSERT INTO Price_Changes_Log
            (
                medicine_id,
                old_price,
                new_price,
                change_type,
                difference_amount
            )
            VALUES
            (
                OLD.medicine_id,
                OLD.price,
                NEW.price,
                'TĂNG GIÁ',
                NEW.price - OLD.price
            );

        ELSE

            INSERT INTO Price_Changes_Log
            (
                medicine_id,
                old_price,
                new_price,
                change_type,
                difference_amount
            )
            VALUES
            (
                OLD.medicine_id,
                OLD.price,
                NEW.price,
                'GIẢM GIÁ',
                OLD.price - NEW.price
            );

        END IF;

    END IF;

END //

DELIMITER ;

UPDATE Medicines
SET price = 20000
WHERE medicine_id = 1;

UPDATE Medicines
SET price = 12000
WHERE medicine_id = 1;

UPDATE Medicines
SET stock = 80
WHERE medicine_id = 1;

UPDATE Medicines
SET price = -5000
WHERE medicine_id = 1;

SELECT * FROM Price_Changes_Log; 