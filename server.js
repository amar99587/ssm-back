const express = require("express");
const cors = require("cors");
const cookies = require("cookie-parser");
const dotenv = require("dotenv");

dotenv.config({ path: "config.env" });

const app = express();

app.use(express.json());
app.use(cookies());
app.use(cors({
    origin: process.env.cors_origin,
    credentials: true
}));

const db = require("./database/main");
const { verifyAuth } = require("./middlewares/auth");

const OTP = require("./OTP/routes");
const users = require("./users/routes");
const schools = require("./schools/routes");
const courses = require("./courses/routes");
const students = require("./students/routes");
const payments = require("./payments/routes");
const lessons = require("./lessons/routes");

app.use(verifyAuth);

app.get('/', (req, res) => {
  const cookie = req.cookies.cookie;

  console.log('cookies', req.cookies, req.cookies.cookie);
  // Use yourCookieValue as needed in the backend logic

  res.send('Backend logic with the cookie value : ' + cookie);
});

app.use("/api/OTP/", OTP);
app.use("/api/users/", users);
app.use("/api/schools/", schools);
app.use("/api/courses", courses);
app.use("/api/students", students);
app.use("/api/payments", payments);
app.use("/api/lessons", lessons);

app.use((req, res, next) => console.log(404));

app.listen(port = process.env.app_port, async () => {
    console.log(`1 - server listening on port ${port}`);
    // try {
    //     await db.connect();
    //     console.log("2 - connection to the database was successful");
    // } catch (error) {
    //     console.log(error);
    // }
});
