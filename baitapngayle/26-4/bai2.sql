USE book_worm;

-- 3 tac gia
INSERT INTO authors(full_name, birth_year, nationality) VALUES
('To Hoai', 1920, 'Viet Nam'),
('Agatha Christie', 1890, 'Anh'),
('Dale Carnegie', 1888, 'My');

-- 8 cuon sach
INSERT INTO books(book_name, category, author_id, price, publish_year) VALUES
('De Men Phieu Luu Ky', 'Van hoc', 1, 50000, 1941),
('Ong gia va bien ca', 'Van hoc', 1, 60000, 1952),
('An mang tren chuyen tau', 'Trinh tham', 2, 90000, 1934),
('Vu an bi an', 'Trinh tham', 2, 85000, 1930),
('Dac nhan tam', 'Ky nang', 3, 120000, 1936),
('Quang ganh lo di', 'Ky nang', 3, 110000, 1948),
('Sach tu duy', 'Ky nang', 3, 95000, 1950),
('Truyen ngan tong hop', 'Van hoc', 1, 70000, 1960);

-- 5 khach hang
INSERT INTO customers(full_name, email, phone) VALUES
('Nguyen Van A', 'a@gmail.com', '0123456789'),
('Tran Thi B', 'b@gmail.com', '0123456788'),
('Le Van C', 'c@gmail.com', '0123456787'),
('Pham Thi D', 'd@gmail.com', '0123456786'),
('Hoang Van E', 'e@gmail.com', '0123456785');

-- thu them 1 khach hang co email bi trung
INSERT INTO customers(full_name, email, phone) VALUES
('Test Trung Email', 'a@gmail.com', '0999999999');

-- ket qua:
-- loi vi email 'a@gmail.com' da ton tai trong bang customers
-- do cot email duoc dat UNIQUE nen khong cho phep trung