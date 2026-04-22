CREATE DATABASE DTB_session02;
USE DTB_session02;

CREATE TABLE books(
	book_id CHAR(5) PRIMARY KEY,
    book_name VARCHAR(200) NOT NULL,
    quantity INT NOT NULL CHECK (quantity>=0),
    rental_price DECIMAL(10,2) DEFAULT 5000 
);

-- tạo bảng borrow_books dựa trên yêu cầu đề bài
CREATE TABLE borrow_book(
	borrow_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id CHAR(5),
    borrow_date DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT FOREIGN KEY (book_id) REFERENCES books(book_id)
);
-- thêm cột
ALTER TABLE books 
ADD COLUMN date_input DATETIME; 

-- xóa cột 
ALTER TABLE books
DROP COLUMN date_input;

-- chỉnh sửa kiểu dữ liệu cột quantity thành double
ALTER TABLE books
MODIFY COLUMN quantity double;

-- chỉnh sửa kiểu dữ liệu cột borrow_books thành DATETIME
ALTER TABLE books
MODIFY COLUMN borrow_date DATETIME DEFAULT (CURRENT_TIMESTAMP);

-- tìm hiểu thay đổi tên của cột 
-- tìm hiểu cú pháp thay đổi giá trị mặc định 
-- yc 1: cập nhật lại tên cột book_name ==> title giữ nguyên kiểu dữ liệu 
-- yc 2: thay đổi giá trị mặc định của rental_price thành 10 000

-- yc 1: 
ALTER TABLE books  
RENAME COLUMN book_name TO bookname_update;

-- yc 2: 
ALTER TABLE books 
ALTER COLUMN 