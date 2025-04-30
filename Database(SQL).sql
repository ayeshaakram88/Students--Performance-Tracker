CREATE TABLE admin_loginT
(
admin_email VARCHAR2(20),
admin_password VARCHAR2(10)
);

INSERT INTO admin_loginT(admin_email,admin_password) VALUES ('admin@gmail.com','admin123');

SELECT * FROM admin_loginT;

CREATE TABLE teacher_loginT
(
teacher_email VARCHAR2(20),
teacher_password VARCHAR2(10)
);

INSERT INTO teacher_loginT(teacher_email,teacher_password) VALUES ('teacher@gmail.com','teacher123');

SELECT * FROM teacher_loginT;

CREATE TABLE parent_loginT
(
parent_email VARCHAR2(20),
parent_password VARCHAR2(10)
);

INSERT INTO parent_loginT(parent_email,parent_password) VALUES ('parent@gmail.com','parent123');

SELECT * FROM parent_loginT;

CREATE TABLE student_loginT
(
student_email VARCHAR2(20),
student_password VARCHAR2(10)
);

INSERT INTO student_loginT(student_email,student_password) VALUES ('student@gmail.com','student123');

SELECT * FROM student_loginT;
-----------admin view stud det
CREATE TABLE studentdet_
(
student_id VARCHAR2(10) NOT NULL PRIMARY KEY,
student_name VARCHAR2(30),
student_semester VARCHAR2(20),
student_dept VARCHAR2(20),
email VARCHAR(20)
);
ALTER TABLE studentdet_
ADD phone NUMBER(11);

ALTER TABLE studentdet_
ADD fathername VARCHAR2(30);

INSERT INTO studentdet_(student_id,student_name, fathername, student_semester,student_dept,email,phone) VALUES ('21-SE-01','Maria Zahid','Zahid Khan','Semester 5','SE','student211@gmail.com',53727925142);
INSERT INTO studentdet_(student_id,student_name,fathername, student_semester,student_dept,email,phone) VALUES ('21-SE-02','Hafsa Ali','Ali Asim', 'Semester 5','SE','student212@gmail.com',45284629052);
INSERT INTO studentdet_(student_id,student_name, fathername, student_semester,student_dept,email,phone) VALUES ('21-SE-03','Usman Khan','Faiz Khan','Semester 5','SE','student213@gmail.com',53778925142);
INSERT INTO studentdet_(student_id,student_name, fathername, student_semester,student_dept,email,phone) VALUES ('21-SE-04','Faiza Maqsood','Maqsood Shabbir','Semester 5','SE','student214@gmail.com',53727925888);
INSERT INTO studentdet_(student_id,student_name, fathername, student_semester,student_dept,email,phone) VALUES ('21-SE-05','Muhammad Ali','Muhammad Ahmed','Semester 5','SE','student215@gmail.com',12327925142);

INSERT INTO studentdet_(student_id,student_name, fathername, student_semester,student_dept,email,phone) VALUES ('22-SE-01','Ahmed Khan','Jamal Khan','Semester 3','SE','student221@gmail.com',78315625142);
INSERT INTO studentdet_(student_id,student_name, fathername, student_semester,student_dept,email,phone) VALUES ('22-SE-02','Daniyal Zaman','Zaman Ali','Semester 3','SE','student222@gmail.com',45627925142);
INSERT INTO studentdet_(student_id,student_name, fathername, student_semester,student_dept,email,phone) VALUES ('22-SE-03','Haiqa Umar','Umar Taimoor','Semester 3','SE','student223@gmail.com',90877925179);
INSERT INTO studentdet_(student_id,student_name, fathername, student_semester,student_dept,email,phone) VALUES ('22-SE-04','Faris Khan','Tariq Khan','Semester 3','SE','student224@gmail.com',63727925112);
INSERT INTO studentdet_(student_id,student_name, fathername, student_semester,student_dept,email,phone) VALUES ('22-SE-05','Aizel Khan','Yahya Khan','Semester 3','SE','student225@gmail.com',43727925646);

INSERT INTO studentdet_(student_id,student_name, fathername, student_semester,student_dept,email,phone) VALUES ('23-SE-01','Zoha Ali','Ali Umar','Semester 1','SE','student231@gmail.com',13727925142);
INSERT INTO studentdet_(student_id,student_name, fathername, student_semester,student_dept,email,phone) VALUES ('23-SE-02','Faiqa Nadeem','Nadeem Arshad','Semester 1','SE','student232@gmail.com',23727925142);
INSERT INTO studentdet_(student_id,student_name, fathername, student_semester,student_dept,email,phone) VALUES ('23-SE-03','Hammad Tariq','Tariq Rehan','Semester 1','SE','student233@gmail.com',33727925142);
INSERT INTO studentdet_(student_id,student_name, fathername, student_semester,student_dept,email,phone) VALUES ('23-SE-04','Javeria Jafri','Abid Hussain','Semester 1','SE','student234@gmail.com',43727925142);
INSERT INTO studentdet_(student_id,student_name, fathername, student_semester,student_dept,email,phone) VALUES ('23-SE-05','Omar Junaid','Junaid Qamar','Semester 1','SE','student235@gmail.com',53727925161);

SELECT * FROM studentdet_;
-------------------------------------------------------------done
-----------------stud parent 

CREATE TABLE teach_det
(
t_id VARCHAR2(10) NOT NULL PRIMARY KEY,
t_name VARCHAR2(10),
email VARCHAR(20),
phone NUMBER(11)
);

INSERT INTO teach_det(t_id,t_name,email,phone) VALUES ('T01','Teacher1','teacher1@gmail.com',12345678910);
SELECT * FROM teach_det;

  CREATE TABLE teacher_courseT
(
    t_id VARCHAR2(10) NOT NULL,
    t_course VARCHAR2(20),
    course_id VARCHAR2(6),
    PRIMARY KEY (t_id, t_course, course_id),
    FOREIGN KEY (t_id) REFERENCES teach_det(t_id)
);


INSERT INTO teacher_courseT(t_id,t_course,course_id) VALUES ('T01','DBS','SE-234');
INSERT INTO teacher_courseT(t_id,t_course,course_id) VALUES ('T01','FMSE','SE-102');

SELECT * FROM teacher_courseT;

--view attendance--
CREATE TABLE sattendance_T
(
 s_id VARCHAR2(10) NOT NULL,
 course_id VARCHAR2(6),
 course_name VARCHAR2(20),
 s_attendance INT,
 semester VARCHAR(20),
 PRIMARY KEY (s_id,course_id,course_name,s_attendance),
 FOREIGN KEY (s_id) REFERENCES studentdet_ (student_id)
);


INSERT INTO sattendance_T(s_id,course_id,course_name,s_attendance,semester) VALUES ('21-SE-01','SE-301','SQE','14','Semester 5');
INSERT INTO sattendance_T(s_id,course_id,course_name,s_attendance,semester) VALUES ('21-SE-01','SE-302','OS','12','Semester 5');
INSERT INTO sattendance_T(s_id,course_id,course_name,s_attendance,semester) VALUES ('21-SE-01','SE-303','DBA','16','Semester 5');
INSERT INTO sattendance_T(s_id,course_id,course_name,s_attendance,semester) VALUES ('21-SE-01','SE-304','CN','16','Semester 5');
INSERT INTO sattendance_T(s_id,course_id,course_name,s_attendance,semester) VALUES ('21-SE-01','SE-305','AA','16','Semester 5');

SELECT * FROM sattendance_T ;



CREATE TABLE contactus_ (
    email VARCHAR2(100)NOT NULL,
    subject VARCHAR2(100),
    message VARCHAR2(500)NOT NULL,
    submit_date DATE
);


Select * From contactus_;

--view teacher details--

SELECT teach_det.t_id,teach_det.t_name ,teach_det.email,teach_det.phone,teacher_courseT.t_course,teacher_courseT.course_id
FROM teach_det,teacher_courseT,course_T
WHERE teach_det.t_id=teacher_courseT.t_id AND teacher_courseT.course_id=course_T.course_id;

--view student details for chairman--

SELECT DISTINCT (studentdet_.st_id),studentdet_.st_name ,studentdet_.st_dept,studentdet_.email,studentdet_.phone,stud_courseT.st_semester,stud_courseT.credits_attained,
    course_T.total_credit_hours,stud_courseT.course_id, 
    course_T.GPA,course_T.grade
FROM studentdet_,stud_courseT,course_T
WHERE studentdet_.st_id = stud_courseT.st_id AND stud_courseT.st_id=course_T.s_id
ORDER BY studentdet_.st_id;

--view details for admin--
SELECT DISTINCT studentdet_.st_id, studentdet_.st_name, studentdet_.st_dept, studentdet_.email, studentdet_.phone, stud_courseT.st_semester
FROM studentdet_
JOIN stud_courseT ON studentdet_.st_id = stud_courseT.st_id
ORDER BY studentdet_.st_id;

--stored procedure--------------------------------------------------------------------------------------------------------------------
CREATE TABLE stud_course (
    student_id VARCHAR2(10),
    course_id VARCHAR2(10),
    course_name VARCHAR2(100),
    semester VARCHAR2(50),
    credit_hours_earned NUMBER,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES studentdet_(student_id)
);


select * from stud_course;
----------------not inserted yet

INSERT INTO stud_course (student_id, course_id, course_name, semester, credit_hours_earned) VALUES ('21-SE-01','SE-301', 'SQE','Semester 5', 3);
INSERT INTO stud_course (student_id, course_id, course_name, semester, credit_hours_earned) VALUES ('21-SE-01','SE-302', 'OS','Semester 5', 3);
INSERT INTO stud_course (student_id, course_id, course_name, semester, credit_hours_earned) VALUES ('21-SE-01','SE-303', 'DBA','Semester 5', 3);
INSERT INTO stud_course (student_id, course_id, course_name, semester, credit_hours_earned) VALUES ('21-SE-01','SE-304', 'CN','Semester 5', 3);
INSERT INTO stud_course (student_id, course_id, course_name, semester, credit_hours_earned) VALUES ('21-SE-01','SE-305', 'AA','Semester 5', 3);

INSERT INTO stud_course (student_id, course_id, course_name, semester, credit_hours_earned) VALUES ('22-SE-01','SE-201', 'SRE','Semester 3', 2);
INSERT INTO stud_course (student_id, course_id, course_name, semester, credit_hours_earned) VALUES ('22-SE-01','SE-202', 'OOP','Semester 3', 3);
INSERT INTO stud_course (student_id, course_id, course_name, semester, credit_hours_earned) VALUES ('22-SE-01','SE-203', 'HCI','Semester 3', 3);
INSERT INTO stud_course (student_id, course_id, course_name, semester, credit_hours_earned) VALUES ('22-SE-01','MG-204', 'MM','Semester 3', 3);
INSERT INTO stud_course (student_id, course_id, course_name, semester, credit_hours_earned) VALUES ('22-SE-01','HU-205', 'TBW','Semester 3', 3);

INSERT INTO stud_course (student_id, course_id, course_name, semester, credit_hours_earned) VALUES ('23-SE-01','SE-101', 'ICT','Semester 1', 2);
INSERT INTO stud_course (student_id, course_id, course_name, semester, credit_hours_earned) VALUES ('23-SE-01','SE-102', 'DS','Semester 1', 3);
INSERT INTO stud_course (student_id, course_id, course_name, semester, credit_hours_earned) VALUES ('23-SE-01','MA-103', 'AP','Semester 1', 3);
INSERT INTO stud_course (student_id, course_id, course_name, semester, credit_hours_earned) VALUES ('23-SE-01','MA-104', 'CAG','Semester 1', 3);
INSERT INTO stud_course (student_id, course_id, course_name, semester, credit_hours_earned) VALUES ('23-SE-01','HU-105', 'ECC','Semester 1', 3);
INSERT INTO stud_course (student_id, course_id, course_name, semester, credit_hours_earned) VALUES ('23-SE-01','HU-106', 'PS','Semester 1', 2);
    

                   
-- Table for Assignments
CREATE TABLE assignment_T (
    student_id VARCHAR(10),
    FOREIGN KEY (student_id) REFERENCES studentdet_ (student_id),
    assignment_id NUMBER,
    assignment_marks NUMBER,
    ao_marks NUMBER,
    course_id VARCHAR(10),
    FOREIGN KEY (course_id, student_id) REFERENCES stud_course (course_id, student_id),
    PRIMARY KEY (assignment_id)
);



select * from assignment_T;

-- Table for Quizzes
CREATE TABLE quiz_T (
    student_id VARCHAR(10),
    FOREIGN KEY (student_id) REFERENCES studentdet_ (student_id),
    quiz_id NUMBER,
    quiz_marks NUMBER,
    qa_marks NUMBER, -- Weightage of the quiz in percentage
    course_id VARCHAR(10),
    FOREIGN KEY (course_id, student_id) REFERENCES stud_course (course_id, student_id),
    PRIMARY KEY (quiz_id)
);

--8----------
-- Table for Performance Records-----------pr4-----------------
CREATE TABLE Performance_T (
    record_id NUMBER PRIMARY KEY,
    course_id VARCHAR(10),
    student_id VARCHAR(10),
    total_final_marks NUMBER,
    final_marks NUMBER,
    total_mids_marks NUMBER,
    mids_marks NUMBER,
    calculated_gpa NUMBER,
    FOREIGN KEY (student_id, course_id) REFERENCES stud_course(student_id, course_id)
);

SELECT * FROM Performance_T;

SELECT 
    sub.semester,
    sub.course_id,
    sub.course_name,
    sub.credit_hours_earned,
    sub.calculated_gpa,
    sub.grade,
    sub.total_gpa,
    CASE 
        WHEN sub.total_gpa >= 4.0 THEN 'A+'
        WHEN sub.total_gpa >= 3.85 THEN 'A'
        WHEN sub.total_gpa >= 3.5 THEN 'A-'
        WHEN sub.total_gpa >= 3.15 THEN 'B+'
        WHEN sub.total_gpa >= 3.0 THEN 'B'
        WHEN sub.total_gpa >= 2.85 THEN 'B-'
        WHEN sub.total_gpa >= 2.5 THEN 'C+'
        WHEN sub.total_gpa >= 2.15 THEN 'C'
        WHEN sub.total_gpa >= 2.0 THEN 'C-'
        WHEN sub.total_gpa >= 1.85 THEN 'D+'
        WHEN sub.total_gpa >= 1.5 THEN 'D'
        ELSE 'F'
    END AS final_grade
FROM 
    (SELECT 
        sc.semester,
        pt.course_id,
        sc.course_name,
        sc.credit_hours_earned,
        pt.calculated_gpa,
        CASE 
            WHEN pt.calculated_gpa >= 4.0 THEN 'A+'
            WHEN pt.calculated_gpa >= 3.85 THEN 'A'
            WHEN pt.calculated_gpa >= 3.5 THEN 'A-'
            WHEN pt.calculated_gpa >= 3.15 THEN 'B+'
            WHEN pt.calculated_gpa >= 3.0 THEN 'B'
            WHEN pt.calculated_gpa >= 2.85 THEN 'B-'
            WHEN pt.calculated_gpa >= 2.5 THEN 'C+'
            WHEN pt.calculated_gpa >= 2.15 THEN 'C'
            WHEN pt.calculated_gpa >= 2.0 THEN 'C-'
            WHEN pt.calculated_gpa >= 1.85 THEN 'D+'
            WHEN pt.calculated_gpa >= 1.5 THEN 'D'
            ELSE 'F'
        END AS grade,
        ROUND(SUM(pt.calculated_gpa * sc.credit_hours_earned) / SUM(sc.credit_hours_earned), 2) AS total_gpa
    FROM 
        Performance_T pt
    INNER JOIN 
        stud_course sc ON pt.course_id = sc.course_id
    WHERE 
        sc.student_id = pt.student_id
        AND pt.student_id = '21-SE-02'
        AND sc.semester = 'Semester 5'
    GROUP BY
        sc.semester, pt.course_id, sc.course_name, sc.credit_hours_earned, pt.calculated_gpa) sub
ORDER BY
    sub.semester;



CREATE SEQUENCE record_id_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;



-----------function
CREATE OR REPLACE FUNCTION CALCULATE_GPA (
    p_weighted_assignment_marks IN NUMBER,
    p_weighted_quiz_marks IN NUMBER,
    p_weighted_mid_marks IN NUMBER,
    p_weighted_final_marks IN NUMBER,
    p_total_credit_hours IN NUMBER
) RETURN NUMBER AS
    v_gpa NUMBER;
    v_total_weighted_marks NUMBER;
BEGIN
    -- Calculate total weighted marks
    v_total_weighted_marks := p_weighted_assignment_marks +
                             p_weighted_quiz_marks +
                             p_weighted_mid_marks +
                             p_weighted_final_marks;

    -- Calculate GPA based on total weighted marks and total credit hours
    -- Example calculation: GPA = (Total Weighted Marks / Total Credit Hours) * 4
    v_gpa := (v_total_weighted_marks / 100) * 4;

    RETURN v_gpa;
END CALCULATE_GPA;
/



------------ procedure
CREATE OR REPLACE PROCEDURE INSERT_Performance_T (
    p_course_id IN Performance_T.course_id%TYPE,
    p_student_id IN Performance_T.student_id%TYPE,
    p_total_final_marks IN Performance_T.total_final_marks%TYPE,
    p_final_marks IN Performance_T.final_marks%TYPE,
    p_total_mids_marks IN Performance_T.total_mids_marks%TYPE,
    p_mids_marks IN Performance_T.mids_marks%TYPE,
    p_weighted_assignment_marks IN NUMBER,
    p_weighted_quiz_marks IN NUMBER
) AS
    v_calculated_gpa NUMBER;
    v_total_credit_hours NUMBER;
    p_weighted_mid_marks NUMBER;
    p_weighted_final_marks NUMBER;
BEGIN
    -- Retrieve credit hours from the course table
    BEGIN
    -- Inside INSERT_Performance_T procedure
FOR course_rec IN (SELECT credit_hours_earned
                   FROM stud_course
                   WHERE course_id = p_course_id) 
LOOP
    v_total_credit_hours := course_rec.credit_hours_earned;
    -- Additional processing logic here
END LOOP;


    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Course not found');
            -- Handle the exception as per your requirements
    END;

    -- Calculate weighted marks and credit hours
    BEGIN
        p_weighted_mid_marks := (p_mids_marks / p_total_mids_marks) * 25;
        p_weighted_final_marks := (p_final_marks / p_total_final_marks) * 50;
    END;

    -- Calculate GPA based on weighted marks and credit hours
    v_calculated_gpa := CALCULATE_GPA(
        p_weighted_assignment_marks,
        p_weighted_quiz_marks,
        p_weighted_mid_marks,
        p_weighted_final_marks,
        v_total_credit_hours
    );

    -- Insert data into Performance_T
    INSERT INTO Performance_T (
        record_id, course_id, student_id, total_final_marks, final_marks, total_mids_marks, mids_marks, calculated_gpa
    ) VALUES (
        record_id_seq.NEXTVAL,
        p_course_id,
        p_student_id,
        p_total_final_marks,
        p_final_marks,
        p_total_mids_marks,
        p_mids_marks,
        v_calculated_gpa
    );

    COMMIT;
END INSERT_Performance_T;
/



--------------------------declaration
DECLARE
    v_course_id VARCHAR2(10) := 'SE-304'; -- replace with the actual course_id
    v_student_id varchar2(10) := 'S-31'; -- replace with the actual student_id
    v_total_final_marks NUMBER := 50; -- replace with the actual values
    v_final_marks NUMBER := 50; -- replace with the actual values
    v_total_mids_marks NUMBER := 25; -- replace with the actual values
    v_mids_marks NUMBER := 25; -- replace with the actual values
    v_weighted_assignment_marks NUMBER := 13; -- replace with the actual values
    v_weighted_quiz_marks NUMBER := 12; -- replace with the actual values
BEGIN
    INSERT_Performance_T(
        p_course_id => v_course_id,
        p_student_id => v_student_id,
        p_total_final_marks => v_total_final_marks,
        p_final_marks => v_final_marks,
        p_total_mids_marks => v_total_mids_marks,
        p_mids_marks => v_mids_marks,
        p_weighted_assignment_marks => v_weighted_assignment_marks,
        p_weighted_quiz_marks => v_weighted_quiz_marks
    );
END;
/
select * from Performance_T;


---------trigger


CREATE OR REPLACE TRIGGER email_validation
BEFORE INSERT OR UPDATE ON teach_det
FOR EACH ROW
BEGIN
    IF :NEW.email IS NOT NULL THEN
        IF NOT REGEXP_LIKE(:NEW.email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$') THEN
            RAISE_APPLICATION_ERROR(-20001, 'Invalid email format');
        END IF;
    END IF;
END;
/