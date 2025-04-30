const express = require("express");
const app = express();
const bodyParser = require("body-parser");
const oracledb = require("oracledb");

app.use(bodyParser.urlencoded({ extended: true })); // Parse URL-encoded bodies

app.use(bodyParser.json());
app.use(express.static("public"));
app.use(express.static(__dirname + "/public"));

// Oracle database configuration
const dbConfig = {
  user: "",
  password: "",
  connectString: "localhost:1521/orcl",
  poolMax: 10, // Adjust as needed
  poolMin: 2, // Adjust as needed
  poolIncrement: 2, // Adjust as needed
};

// Initialize and configure the Oracle connection pool
async function initialize() {
  try {
    await oracledb.createPool(dbConfig);
    console.log("Oracle connection pool created.");
  } catch (err) {
    console.error("Error creating Oracle connection pool:", err);
  }
}

initialize();

app.get("/", (req, res) => {
  res.sendFile(__dirname + "/attendance_chart.html");
});

//attendance chart
// app.post('/attendance', async (req, res) => {
//   let connection;
// console.log(req.body);
// const {s_id,semester}=req.body;

//   try {
//     connection = await oracledb.getConnection(dbConfig);

//     console.log("data");
//     const result = await connection.execute(
//       `SELECT * FROM attendanceT WHERE (s_id=:s_id AND semester=:semester)`,[s_id,semester]
//     );

//     console.log(result.rows);
//     res.sendFile(__dirname + '/public/attendance_chart.html')
//   } catch (error) {
//     console.error('Error fetching data from Oracle:', error);
//     res.status(500).json({ error: 'Internal server error' });
//   } finally {
//     if (connection) {
//       try {
//         await connection.close();
//       } catch (error) {
//         console.error('Error closing connection:', error);
//       }
//     }
//   }
// });

//stud_attendance
app.post("/attendance", async (req, res) => {
  let connection;

  try {
    console.log(req.body);
    const { s_id, semester } = req.body;

    console.log("Received s_id:", s_id);
    console.log("Received semester:", semester);

    connection = await oracledb.getConnection(dbConfig);

    const result = await connection.execute(
      `SELECT * FROM sattendance_T WHERE s_id = :s_id AND semester = :semester`,
      { s_id, semester }
    );
    connection.commit();
    console.log("Query Result:", result.rows);

    const attendance = result.rows;

    if (result.rows.length === 0) {
      console.log("No matching records found.");
      return res.status(404).json({ message: "No records found" });
    }

    const attendanceJSON = JSON.stringify(attendance); // Convert attendance to JSON string

    // Redirect to attendance_chart.html and pass attendance as a query parameter
    res.redirect(
      `/attendance_chart.html?attendance=${encodeURIComponent(attendanceJSON)}`
    );
  } catch (error) {
    console.error("Error fetching data from Oracle:", error);
    res.status(500).json({ error: "Internal server error" });
  } finally {
    if (connection) {
      try {
        await connection.close();
      } catch (error) {
        console.error("Error closing connection:", error);
      }
    }
  }
});

//admin login
app.post("/login", async (req, res) => {
  console.log(req.body);
  const { email, password } = req.body;
  console.log(req.body);

  try {
    // Connect to the Oracle database
    const connection = await oracledb.getConnection(dbConfig);

    // Execute the query to fetch data based on email and password
    const result = await connection.execute(
      `SELECT * FROM admin_loginT WHERE admin_email = :email AND admin_password = :password`,
      [email, password]
    );

    // Check if user authentication was successful based on query result
    if (result.rows.length > 0) {
      // Successful login
      const responseData = {
        success: true,
        user: result.rows[0], // Modify this according to your user schema
      };
      res.json(responseData);
    } else {
      // Failed login
      const responseData = {
        success: false,
        message: "Invalid email or password",
      };
      res.json(responseData);
    }

    // Release the Oracle database connection
    await connection.close();
  } catch (error) {
    // Handle any errors that occur during the process
    console.error("Error:", error);
    res.status(500).json({ success: false, message: "Internal Server Error" });
  }
});

// marks display
app.post("/getMarksData", async (req, res) => {
  let connection;

  try {
    console.log(req.body);
    const { s_id, semester } = req.body; // Extracting s_id from the request body

    console.log("Received s_id:", s_id);

    connection = await oracledb.getConnection(dbConfig);

    const result = await connection.execute(
      `SELECT 
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
  FROM (
      SELECT 
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
          AND pt.student_id = :student_id
          AND sc.semester = :semester
      GROUP BY
          sc.semester, pt.course_id, sc.course_name, sc.credit_hours_earned, pt.calculated_gpa
  ) sub
  ORDER BY
      sub.semester
  `,
      [s_id, semester] // Using s_id as student_id parameter in the query
    );

    connection.commit();
    console.log("Query Result:", result.rows);

    const data = result.rows;

    if (result.rows.length === 0) {
      console.log("No matching records found.");
      return res.status(404).json({ message: "No records found" });
    }

    // Sending the data in response
    const r = result.rows;
    const dataToSendToFrontend = JSON.stringify(r); // Convert the data to a string

    // Redirect to marks_chart.html with the data as a query parameter
    res.redirect(
      `/marks_chart.html?data=${encodeURIComponent(dataToSendToFrontend)}`
    );
  } catch (error) {
    console.error("Error fetching data from Oracle:", error);
    res.status(500).json({ error: "Internal server error" });
  } finally {
    if (connection) {
      try {
        await connection.close();
      } catch (error) {
        console.error("Error closing connection:", error);
      }
    }
  }
});

//student details display
app.get("/students", async (req, res) => {
  try {
    const connection = await oracledb.getConnection(dbConfig);

    const result = await connection.execute("SELECT * FROM studentdet_");
    const data = result.rows.map((row) => ({
      ID: row[0],
      Name: row[1],
      Semester: row[2],
      Department: row[3],
      "E-mail": row[4],
      "Phone Number": row[5],
      "Father Name": row[6], // Adjust as per your database structure
    }));

    await connection.close();

    res.json({ data });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.use(express.urlencoded({ extended: true }));
app.use(express.static("public")); // Serving static files like HTML, CSS, and JS from 'public' folder

//teacher insert attendance
app.post("/submitAttendance", async (req, res) => {
  try {
    const { s_id, course_id, course_name, s_attendance, semester } = req.body;

    const connection = await oracledb.getConnection(dbConfig);

    // Use the received form data to construct and execute an INSERT query
    const result = await connection.execute(
      `INSERT INTO sattendance_T (s_id, course_id, course_name, s_attendance, semester) VALUES (:s_id, :course_id, :course_name, :s_attendance, :semester)`,
      [s_id, course_id, course_name, s_attendance, semester]
    );
    console.log(result);
    await connection.commit();
    await connection.close();

    res.send("Attendance submitted successfully");
  } catch (error) {
    res.status(500).send("Error submitting attendance");
    console.error("Error:", error);
  }
});

//admin enter student details
app.post("/submitStudent", async (req, res) => {
  const {
    student_id,
    student_name,
    student_semester,
    student_dept,
    email,
    phone,
    fathername,
  } = req.body;

  try {
    console.log("1");
    const connection = await oracledb.getConnection();
    console.log("2");
    // Adjust this SQL query according to your database schema
    const sql = `INSERT INTO studentdet_ (student_id, student_name, student_semester, student_dept, email, phone, fathername) 
                 VALUES (:student_id, :student_name, :student_semester, :student_dept, :email, :phone, :fathername)`;

    const result = await connection.execute(sql, {
      student_id,
      student_name,
      student_semester,
      student_dept,
      email,
      phone,
      fathername,
    });

    console.log("3");
    await connection.commit();
    await connection.close();

    res.status(200).json({ message: "Data inserted successfully" });
  } catch (err) {
    console.error("Error inserting data: ", err);
    res.status(500).json({ message: "Failed to insert data" });
  }
});

//admin enter teacher details
app.post("/submitTeacher", async (req, res) => {
  const { t_id, t_name, email, phone } = req.body;

  try {
    const connection = await oracledb.getConnection();

    // Adjust this SQL query according to your database schema
    const sql = `INSERT INTO teach_det (t_id, t_name, email, phone) 
                 VALUES (:t_id, :t_name, :email, :phone)`;

    const result = await connection.execute(sql, {
      t_id,
      t_name,
      email,
      phone,
    });

    await connection.commit();
    await connection.close();

    res.status(200).json({ message: "Teacher data inserted successfully" });
  } catch (err) {
    console.error("Error inserting teacher data: ", err);
    res.status(500).json({ message: "Failed to insert teacher data" });
  }
});

//teach details display
app.get("/teachers", async (req, res) => {
  try {
    const connection = await oracledb.getConnection(dbConfig);

    const result = await connection.execute("SELECT * FROM teach_det");
    const data = result.rows.map((row) => ({
      ID: row[0],
      Name: row[1],
      "Phone Number": row[2],
      "E-mail": row[3],
    }));

    await connection.close();

    res.json({ data });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

//validation_s
app.post("/logins", async (req, res) => {
  const { email, password } = req.body;
  console.log(req.body);

  try {
    const connection = await oracledb.getConnection(dbConfig);

    const result = await connection.execute(
      `SELECT * FROM student_loginT WHERE student_email = :email AND student_password = :password`,
      { email, password }
    );

    await connection.close();

    if (result.rows.length > 0) {
      res.json({ success: true });
    } else {
      res.json({ success: false });
    }
  } catch (error) {
    console.error("Error:", error.message);
    res.status(500).json({ success: false, error: "Internal server error" });
  }
});

//validation t
app.post("/logint", async (req, res) => {
  const { email, password } = req.body;

  try {
    const connection = await oracledb.getConnection(dbConfig);

    const result = await connection.execute(
      `SELECT * FROM teacher_loginT WHERE teacher_email = :email AND teacher_password = :password`,
      { email, password }
    );

    await connection.close();

    if (result.rows.length > 0) {
      res.json({ success: true });
    } else {
      res.json({ success: false });
    }
  } catch (error) {
    console.error("Error:", error.message);
    res.status(500).json({ success: false, error: "Internal server error" });
  }
});

//validation p
app.post("/loginp", async (req, res) => {
  console.log(req.body);
  const { email, password } = req.body;
  console.log(req.body);

  try {
    // Connect to the Oracle database
    const connection = await oracledb.getConnection(dbConfig);

    // Execute the query to fetch data based on email and password
    const result = await connection.execute(
      `SELECT * FROM parent_loginT WHERE parent_email = :email AND parent_password = :password`,
      [email, password]
    );

    // Check if user authentication was successful based on query result
    if (result.rows.length > 0) {
      // Successful login
      const responseData = {
        success: true,
        user: result.rows[0], // Modify this according to your user schema
      };
      res.json(responseData);
    } else {
      // Failed login
      const responseData = {
        success: false,
        message: "Invalid email or password",
      };
      res.json(responseData);
    }

    // Release the Oracle database connection
    await connection.close();
  } catch (error) {
    // Handle any errors that occur during the process
    console.error("Error:", error);
    res.status(500).json({ success: false, message: "Internal Server Error" });
  }
});

//contact us
app.post("/contactUs", async (req, res) => {
  const { email, subject, message } = req.body;

  try {
    const connection = await oracledb.getConnection();

    // Adjust this SQL query according to your database schema
    const sql = `INSERT INTO contactus_ (email, subject, message, submit_date) 
                   VALUES (:email, :subject, :message, SYSDATE)`;

    const result = await connection.execute(sql, {
      email,
      subject,
      message,
    });

    await connection.commit();
    await connection.close();

    res.status(200).json({ message: "Form data inserted successfully" });
  } catch (err) {
    console.error("Error inserting form data: ", err);
    res.status(500).json({ message: "Failed to insert form data" });
  }
});
let id;
let cid;

/// teacher enter student marks
app.post("/page1", async (req, res) => {
  const { student_id, course_id, course_name, semester, credit_hours_earned } =
    req.body;
  id = student_id;
  cid = course_id;
  console.log(id);
  try {
    const connection = await oracledb.getConnection(dbConfig);
    const query = `INSERT INTO stud_course (student_id, course_id, course_name, semester, credit_hours_earned)
                   VALUES (:student_id, :course_id, :course_name, :semester, :credit_hours_earned)`;
    const params = {
      student_id: student_id,
      course_id: course_id,
      course_name: course_name,
      semester: semester,
      credit_hours_earned: credit_hours_earned,
    };
    await connection.execute(query, params, { autoCommit: true });
    await connection.close();

    res.redirect("page2.html"); // Redirect to Page 2 after successful insert
  } catch (err) {
    console.error(err);
    res.status(500).send("Error inserting data");
  }
});

// Endpoint for Page 2 - Assignment and Quizzes
app.post("/page2", async (req, res) => {
  const assignments = req.body.assignment1 || [];
  const assignmentMarks = req.body.assignment2 || [];
  const obtainedAssignmentMarks = req.body.assignment3 || [];
  const quizzes = req.body.quiz1 || [];
  const quizMarks = req.body.quiz2 || [];
  const obtainedQuizMarks = req.body.quiz3 || [];

  let totalAssignmentMarks = 0;
  let totalQuizMarks = 0;
  try {
    const connection = await oracledb.getConnection(dbConfig);
    console.log("Page 2" + id);

    const assignIdResult = await connection.execute(
      `SELECT MAX(assignment_id) FROM assignment_T`
    );
    const maxAssignmentId = assignIdResult.rows[0][0] || 0;

    const quizIdResult = await connection.execute(
      `SELECT MAX(quiz_id) FROM quiz_T`
    );
    const maxQuizId = quizIdResult.rows[0][0] || 0;

    // Insert Assignments
    for (let i = 0; i < assignments.length; i++) {
      const query = `INSERT INTO assignment_T (student_id, course_id, assignment_id, assignment_marks, ao_marks)
                     VALUES (:student_id, :course_id, :assignment_id, :assignment_marks, :ao_marks)`;
      const params = {
        student_id: id,
        course_id: cid,
        assignment_id: maxAssignmentId + i + 1,
        assignment_marks: assignmentMarks[i],
        ao_marks: obtainedAssignmentMarks[i],
      };

      totalAssignmentMarks += parseFloat(assignmentMarks[i]) || 0;
      await connection.execute(query, params, { autoCommit: true });
    }

    console.log("____");

    // Insert Quizzes
    for (let i = 0; i < quizzes.length; i++) {
      const query = `INSERT INTO quiz_T (student_id, course_id, quiz_id, quiz_marks, qa_marks)
                     VALUES (:student_id, :course_id, :quiz_id, :quiz_marks, :qa_marks)`;
      const params = {
        student_id: id,
        course_id: cid,
        quiz_id: maxQuizId + i + 1,
        quiz_marks: quizMarks[i],
        qa_marks: obtainedQuizMarks[i],
      };
      totalQuizMarks += parseFloat(quizMarks[i]) || 0;
      await connection.execute(query, params, { autoCommit: true });
    }

    await connection.close();
    const weightedTotalAssignmentMarks = (totalAssignmentMarks * 0.13).toFixed(
      2
    );
    const weightedTotalQuizMarks = (totalQuizMarks * 0.12).toFixed(2);

    // Redirect to Page 3 with necessary data
    res.redirect(
      `/page3.html?weightedAssignmentMarks=${weightedTotalAssignmentMarks}&weightedQuizMarks=${weightedTotalQuizMarks}`
    );
  } catch (err) {
    console.error(err);
    res.status(500).send("Error inserting data");
  }
});

// Endpoint for Page 3 - Total Marks and GPA
app.post("/page3", async (req, res) => {
  const { total_final_marks, final_marks, total_mids_marks, mids_marks } =
    req.body;

  console.log(req.body);
  console.log(id);
  console.log(cid);
  const weightedAssignmentMarks = req.query.weightedAssignmentMarks || 0;
  const weightedQuizMarks = req.query.weightedQuizMarks || 0;

  try {
    const connection = await oracledb.getConnection(dbConfig);

    // Fetch the next value from the sequence for record_id
    // const recordIdResult = await connection.execute(`SELECT record_id_seq.NEXTVAL FROM DUAL`);
    // const recordId = recordIdResult.rows[0][0]; // Extracting the generated record_id

    // Call the stored procedure instead of executing the insert query
    const procedureQuery = `BEGIN INSERT_Performance_T(:course_id, :student_id, :total_final_marks, :final_marks, :total_mids_marks, :mids_marks, :weighted_assignment_marks, :weighted_quiz_marks); END;`;
    const params = {
      course_id: cid,
      student_id: id,
      total_final_marks,
      final_marks: final_marks,
      total_mids_marks: total_mids_marks,
      mids_marks: mids_marks,
      weighted_assignment_marks: weightedAssignmentMarks,
      weighted_quiz_marks: weightedQuizMarks,
    };

    await connection.execute(procedureQuery, params, { autoCommit: true });

    await connection.close();
    console.log("************");
    res.send("Data inserted successfully");
  } catch (err) {
    console.error(err);
    res.status(500).send("Error inserting data");
  }
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
