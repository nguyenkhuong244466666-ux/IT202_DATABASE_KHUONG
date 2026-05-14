CREATE DATABASE StudentDB;
USE StudentDB;

-- 1. Bảng Khoa
CREATE TABLE Department (
    DeptID VARCHAR(5) PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

-- 2. Bảng SinhVien
CREATE TABLE Student (
    StudentID VARCHAR(6) PRIMARY KEY,
    FullName VARCHAR(50),
    Gender VARCHAR(10),
    BirthDate DATE,
    DeptID VARCHAR(5),
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

-- 3. Bảng MonHoc
CREATE TABLE Course (
    CourseID VARCHAR(6) PRIMARY KEY,
    CourseName VARCHAR(50),
    Credits INT
);

-- 4. Bảng DangKy
CREATE TABLE Enrollment (
    StudentID VARCHAR(6),
    CourseID VARCHAR(6),
    Score DECIMAL(4,2), 
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Chèn dữ liệu mẫu
INSERT INTO Department VALUES
('IT','Information Technology'),
('BA','Business Administration'),
('ACC','Accounting');

INSERT INTO Student VALUES
('S00001','Nguyen An','Male','2003-05-10','IT'),
('S00002','Tran Binh','Male','2003-06-15','IT'),
('S00003','Le Hoa','Female','2003-08-20','BA'),
('S00004','Pham Minh','Male','2002-12-12','ACC'),
('S00005','Vo Lan','Female','2003-03-01','IT'),
('S00006','Do Hung','Male','2002-11-11','BA'),
('S00007','Nguyen Mai','Female','2003-07-07','ACC'),
('S00008','Tran Phuc','Male','2003-09-09','IT');

INSERT INTO Course (CourseID, CourseName, Credits) VALUES ('CS101', 'C Programming', 3), 
('CS102', 'Database Management', 4),
 ('BA201', 'Principles of Marketing', 3), 
('ACC301', 'Financial Accounting', 3),
 ('CS103', 'Java Programming', 4); 

INSERT INTO Enrollment (StudentID, CourseID, Score) VALUES
-- Sinh viên IT học lập trình và cơ sở dữ liệu
('S00001', 'CS101', 8.5),
('S00001', 'CS102', 7.0),
('S00002', 'CS101', 9.0),
('S00002', 'CS103', 8.0),
('S00005', 'CS102', 6.5),
('S00008', 'CS101', 7.5),

-- Sinh viên BA học Marketing
('S00003', 'BA201', 8.0),
('S00006', 'BA201', 7.5),

-- Sinh viên ACC học Kế toán
('S00004', 'ACC301', 9.5),
('S00007', 'ACC301', 8.0);

-- A
CREATE VIEW ViewStudentBasic AS 
SELECT StudentID, FullName, DeptName
FROM student stu
INNER JOIN department dpm
ON stu.DeptID = dpm.DeptID;

SELECT * FROM ViewStudentBasic; 

CREATE INDEX idxFullName ON student(FullName);

DELIMITER //
CREATE PROCEDURE GetStudentsIT()
	BEGIN
		SELECT stu.*, dpm.DeptName
        FROM student stu
        INNER JOIN department dpm
        ON stu.DeptID = dpm.DeptID
        WHERE dpm.DeptName='Information Technology';
    END//
DELIMITER ;
CALL GetStudentsIT();

-- B
CREATE VIEW ViewStudentCountByDep AS 
SELECT dpm.DeptName, COUNT(stu.DeptID) AS TotalStudents
FROM student stu
INNER JOIN department dpm
ON stu.DeptID = dpm.DeptID
GROUP BY stu.DeptID;
SELECT * FROM ViewStudentCountByDep;

SELECT * 
FROM ViewStudentCountByDep
WHERE TotalStudents IN (
	SELECT MAX(TotalStudents)
    FROM ViewStudentCountByDep
);




DELIMITER //
CREATE PROCEDURE GetTopScoreStudent(IN varCourseID VARCHAR(6))
	BEGIN
		SELECT 
        FROM 
        INNER JOIN 
        ON 
        
    END//
DELIMITER ;
CALL GetStudentsIT();





