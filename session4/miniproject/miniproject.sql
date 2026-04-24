CREATE DATABASE dtb_ss4;
USE dtb_ss4;

drop table if exists Student ;
drop table if exists Course ;
drop table if exists Instructor ;
drop table if exists CourseInstructor ;
drop table if exists Enrollment ;
drop table if exists Result ;


CREATE TABLE Student (
  student_id   INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
  full_name    VARCHAR(100) NOT NULL,
  birth_date   DATE         NOT NULL,
  email        VARCHAR(150) NOT NULL UNIQUE
  
);


CREATE TABLE Course (
  course_id      INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
  course_name    VARCHAR(200) NOT NULL,
  description    TEXT,
  total_sessions INT          NOT NULL DEFAULT 0 CHECK (total_sessions >= 0)
);

-- Bang Instructor (Giang vien)

CREATE TABLE Instructor (

  instructor_id INT          NOT NULL AUTO_INCREMENT PRIMARY KEY ,
  full_name     VARCHAR(100) NOT NULL,
  email         VARCHAR(150) NOT NULL UNIQUE 
);

-- -------------------------------------------------------
-- Bang CourseInstructor (Giang vien phu trach khoa hoc - N-N)
-- Mot giang vien co the day nhieu khoa hoc
-- -------------------------------------------------------
CREATE TABLE CourseInstructor (
  course_id     INT NOT NULL,
  instructor_id INT NOT NULL,
  CONSTRAINT pk_ci          PRIMARY KEY (course_id, instructor_id),
  CONSTRAINT fk_ci_course   FOREIGN KEY (course_id)
    REFERENCES Course(course_id)     ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_ci_instr    FOREIGN KEY (instructor_id)
    REFERENCES Instructor(instructor_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- -------------------------------------------------------
-- Bang Enrollment (Dang ky hoc)
-- Sinh vien khong duoc dang ky trung mot khoa hoc (UNIQUE)
-- -------------------------------------------------------
CREATE TABLE Enrollment (
  enrollment_id INT  NOT NULL AUTO_INCREMENT,
  student_id    INT  NOT NULL,
  course_id     INT  NOT NULL,
  enroll_date   DATE NOT NULL DEFAULT (CURRENT_DATE),
  CONSTRAINT pk_enrollment  PRIMARY KEY (enrollment_id),
  CONSTRAINT uq_enroll      UNIQUE      (student_id, course_id),
  CONSTRAINT fk_enroll_stu  FOREIGN KEY (student_id)
    REFERENCES Student(student_id)  ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_enroll_crs  FOREIGN KEY (course_id)
    REFERENCES Course(course_id)    ON DELETE CASCADE ON UPDATE CASCADE
);

-- -------------------------------------------------------
-- Bang Result (Ket qua hoc tap)
-- Diem tu 0 den 10; moi sinh vien chi co 1 ket qua moi khoa
-- -------------------------------------------------------
CREATE TABLE Result (
  result_id      INT           NOT NULL AUTO_INCREMENT,
  student_id     INT           NOT NULL,
  course_id      INT           NOT NULL,
  midterm_score  DECIMAL(4,2),
  final_score    DECIMAL(4,2),
  CONSTRAINT pk_result        PRIMARY KEY (result_id),
  CONSTRAINT uq_result        UNIQUE      (student_id, course_id),
  CONSTRAINT fk_result_stu    FOREIGN KEY (student_id)
    REFERENCES Student(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_result_crs    FOREIGN KEY (course_id)
    REFERENCES Course(course_id)   ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT chk_midterm      CHECK (midterm_score BETWEEN 0 AND 10),
  CONSTRAINT chk_final        CHECK (final_score   BETWEEN 0 AND 10)
);


-- ============================================================
--  PHAN II: NHAP DU LIEU BAN DAU (DML - INSERT)
-- ============================================================

-- 5 Sinh vien
INSERT INTO Student (full_name, birth_date, email) VALUES
  ('Nguyen Van An',   '2002-03-15', 'an.nguyen@student.edu.vn'),
  ('Tran Thi Bich',   '2001-07-22', 'bich.tran@student.edu.vn'),
  ('Le Hoang Cuong',  '2003-01-10', 'cuong.le@student.edu.vn'),
  ('Pham Thi Dung',   '2002-11-05', 'dung.pham@student.edu.vn'),
  ('Hoang Minh Em',   '2001-09-30', 'em.hoang@student.edu.vn');

-- 5 Khoa hoc
INSERT INTO Course (course_name, description, total_sessions) VALUES
  ('Co so du lieu',
   'Nhap mon SQL va thiet ke co so du lieu quan he',           30),
  ('Lap trinh Python',
   'Python co ban den nang cao, bao gom OOP va thu vien pho bien', 45),
  ('Giai tich 1',
   'Vi tich phan ham mot bien',                               30),
  ('Mang may tinh',
   'Kien truc mang va giao thuc TCP/IP',                      30),
  ('Tri tue nhan tao',
   'Nhap mon Machine Learning va cac thuat toan AI co ban',   36);

-- 5 Giang vien
INSERT INTO Instructor (full_name, email) VALUES
  ('TS. Nguyen Quoc Anh',  'quoc.anh@university.edu.vn'),
  ('ThS. Tran Le Bao',     'le.bao@university.edu.vn'),
  ('TS. Pham Van Chinh',   'van.chinh@university.edu.vn'),
  ('GS. Le Thi Dao',       'thi.dao@university.edu.vn'),
  ('ThS. Hoang Duc Em',    'duc.em@university.edu.vn');

-- Phan cong giang vien day khoa hoc
INSERT INTO CourseInstructor (course_id, instructor_id) VALUES
  (1, 1),  -- Co so du lieu      <- TS. Nguyen Quoc Anh
  (2, 2),  -- Lap trinh Python   <- ThS. Tran Le Bao
  (2, 5),  -- Lap trinh Python   <- ThS. Hoang Duc Em (day cung)
  (3, 4),  -- Giai tich 1        <- GS. Le Thi Dao
  (4, 3),  -- Mang may tinh      <- TS. Pham Van Chinh
  (5, 5);  -- Tri tue nhan tao   <- ThS. Hoang Duc Em

-- Dang ky hoc (Enrollment)
INSERT INTO Enrollment (student_id, course_id, enroll_date) VALUES
  (1, 1, '2024-09-01'),
  (1, 2, '2024-09-01'),
  (2, 1, '2024-09-02'),
  (2, 3, '2024-09-02'),
  (3, 2, '2024-09-03'),
  (3, 4, '2024-09-03'),
  (4, 5, '2024-09-04'),
  (4, 1, '2024-09-04'),
  (5, 3, '2024-09-05');

-- Ket qua hoc tap (Result)
INSERT INTO Result (student_id, course_id, midterm_score, final_score) VALUES
  (1, 1, 7.5,  8.0),
  (1, 2, 6.0,  7.5),
  (2, 1, 8.5,  9.0),
  (2, 3, 5.5,  6.0),
  (3, 2, 7.0,  7.0),
  (3, 4, 8.0,  8.5),
  (4, 5, 9.0,  9.5),
  (4, 1, 6.5,  7.0),
  (5, 3, 7.5,  8.0);


-- ============================================================
--  PHAN III: CAP NHAT DU LIEU (DML - UPDATE)
-- ============================================================

-- Cap nhat email cho sinh vien co student_id = 3
UPDATE Student
SET    email = 'cuong.le.new@student.edu.vn'
WHERE  student_id = 3;

-- Cap nhat mo ta cho khoa hoc co course_id = 1
UPDATE Course
SET    description = 'Thiet ke CSDL quan he, SQL nang cao va toi uu hoa truy van'
WHERE  course_id = 1;

-- Cap nhat diem cuoi ky cho sinh vien 2, khoa hoc 3
UPDATE Result
SET    final_score = 7.0
WHERE  student_id = 2 AND course_id = 3;


-- ============================================================
--  PHAN IV: XOA DU LIEU (DML - DELETE)
-- ============================================================

-- Xoa ket qua hoc tap truoc de tranh vi pham rang buoc khoa ngoai
DELETE FROM Result
WHERE  student_id = 5 AND course_id = 3;

-- Xoa luot dang ky khong hop le (sinh vien 5, khoa hoc 3)
DELETE FROM Enrollment
WHERE  student_id = 5 AND course_id = 3;


-- ============================================================
--  PHAN V: TRUY VAN DU LIEU (DML - SELECT)
-- ============================================================

-- 1. Danh sach tat ca sinh vien
SELECT student_id,
       full_name,
       birth_date,
       email
FROM   Student
ORDER  BY student_id;

-- 2. Danh sach giang vien
SELECT instructor_id,
       full_name,
       email
FROM   Instructor
ORDER  BY instructor_id;

-- 3. Danh sach cac khoa hoc
SELECT course_id,
       course_name,
       description,
       total_sessions
FROM   Course
ORDER  BY course_id;

-- 4. Thong tin cac luot dang ky khoa hoc (co ten sinh vien va ten khoa hoc)
SELECT e.enrollment_id,
       s.full_name    AS ten_sinh_vien,
       c.course_name  AS ten_khoa_hoc,
       e.enroll_date  AS ngay_dang_ky
FROM   Enrollment e
       JOIN Student s ON e.student_id = s.student_id
       JOIN Course  c ON e.course_id  = c.course_id
ORDER  BY e.enrollment_id;

-- 5. Thong tin ket qua hoc tap (co diem tong ket = midterm*40% + final*60%)
SELECT r.result_id,
       s.full_name                                        AS ten_sinh_vien,
       c.course_name                                      AS ten_khoa_hoc,
       r.midterm_score                                    AS diem_giua_ky,
       r.final_score                                      AS diem_cuoi_ky,
       ROUND(r.midterm_score * 0.4 + r.final_score * 0.6, 2) AS diem_tong_ket
FROM   Result r
       JOIN Student s ON r.student_id = s.student_id
       JOIN Course  c ON r.course_id  = c.course_id
ORDER  BY r.result_id;
