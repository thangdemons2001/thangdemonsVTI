DROP DATABASE IF EXISTS QuanLy;
CREATE DATABASE QuanLy;
USE QuanLy;

DROP TABLE IF EXISTS Student;
CREATE TABLE Student (
	Student_id		INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Student_name	VARCHAR(50) NOT NULL,
    Age				INT,
    Gender			INT
);

DROP TABLE IF EXISTS `subject`;
CREATE TABLE `subject` (
	subject_id 		INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    subject_name	VARCHAR(50)
);

DROP TABLE IF EXISTS StudentSubject;
CREATE TABLE StudentSubject (
	student_id		INT UNSIGNED,
    FOREIGN KEY (student_id) references Student(student_id),
    subject_id		INT UNSIGNED,
    FOREIGN KEY (subject_id) references `subject`(subject_id),
    mark			INT UNSIGNED,
    `date`			datetime
);
-- question1
INSERT INTO student (student_name, age, gender )
VALUES				   ('Nguyen Duc Thang', '18',  0	),
						('Nguyen Duc Thang1', '18',  0		),
                        ('Nguyen Duc Thang2', '18',  0		),
                        ('Nguyen Duc Thang3', '19',  1		),
                        ('Nguyen Duc Thang4', '18',  0		),
                        ('Nguyen Duc Thang5', '18',  0		),
                        ('Nguyen Duc Thang6', '20',  1		),
                        ('Nguyen Duc Thang7', '21',  0		),
                        ('Nguyen Duc Thang8', '16',  1		),
                        ('Nguyen Duc Thang8', '22',  NULL	);
                        
INSERT INTO `subject` (subject_name)
VALUES				('Toan'),
					('Ly'),
                    ('Hoa'),
                    ('Van'),
                    ('Anh'),
                    ('Sinh'),
                    ('Lich Su'),
                    ('Dia'),
                    ('GDCD'),
                    ('GDQP'),
                    ('Tin Hoc'),
                    ('Cong Nghe');
                    
INSERT INTO studentSubject(student_id, subject_id, mark, `date`)
VALUES					(1,3,10,'2020-01-12'),
						(1,4,10,'2020-01-12'),
                        (1,5,10,'2020-01-12'),
                        (2,3,10,'2020-01-13'),
                        (3,1,10,'2020-01-14'),
                        (4,3,10,'2020-01-15'),
                        (5,3,10,'2020-01-16'),
                        (6,3,10,'2020-01-17'),
                        (7,1,10,'2020-01-18'),
                        (8,3,10,'2020-01-19'),
                        (9,3,10,'2020-01-20'),
                        (1,1,10,'2020-01-21'),
                        (1,2,10,'2020-01-22'),
                        (4,1,10,'2020-01-23');
                        
                        
-- question2
-- a)
SELECT 
    *
FROM
    `subject` sub
WHERE
    sub.subject_id NOT IN (SELECT 
            subSt.Subject_id
        FROM
            studentSubject subSt);
-- b) 
SELECT 
	sub.subject_name
FROM 
	`subject` sub
WHERE
	sub.subject_id IN (
	SELECT 
		subSt.subject_id AS ID
		-- count(subSt.subject_id)
	FROM
		studentSubject subSt
	GROUP BY subSt.subject_id
	HAVING count(subSt.subject_id) >= 2);
    
-- question3
CREATE OR REPLACE VIEW StudentInfo
AS
	SELECT 
		st.Student_id, 
        st.Student_name,
        st.age,
        IF((st.gender = 0), 'Male' , IF((st.gender = 1), 'Female', 'Unknow') ) AS Gender,
        sb.subject_id,
        (SELECT 
			sub.subject_name
		FROM
			`subject` sub
		WHERE
			sub.subject_id = sb.subject_id
		) AS Subject_NAME,
        sb.mark,
        sb.`date`
	FROM
		student st
	LEFT JOIN
		studentSubject sb
	ON st.student_id = sb.student_id;
	
SELECT 	* 
FROM 	StudentInfo;
-- question4


DROP TRIGGER IF EXISTS SubjectDeleTeID;
DELIMITER $$
CREATE TRIGGER SubjectDeleTeID
AFTER DELETE ON `subject`
FOR EACH ROW
BEGIN
	DELETE	
    FROM StudentSubject
	WHERE
		StudentSubject.subject_id = OLD.subject_id;
END$$
DELIMITER ;
SET FOREIGN_KEY_CHECKS=0;
SET SQL_SAFE_UPDATES = 0;
DELETE 
FROM `subject`
WHERE
	`subject`.subject_id = 1;
    
    
-- question5
DROP PROCEDURE IF EXISTS delete_student;
DELIMITER $$
CREATE PROCEDURE delete_student (IN studentName VARCHAR(50))
BEGIN
	IF studentName = '*' THEN
		DELETE
		FROM student;
    ELSE
		DELETE
		FROM student
        WHERE student.student_name = studentname;
	END IF;
END$$
DELIMITER ;
CALL delete_student('Nguyen Duc Thang');