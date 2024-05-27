const express = require("express");
const cors = require("cors");
const cookies = require("cookie-parser");
const dotenv = require("dotenv");

dotenv.config();

const app = express();

app.use(express.json());
app.use(cookies());
app.use(cors({
    origin: process.env.cors_origin,
    credentials: true
}));

//process.setMaxListeners(0);

const db = require("./database/main");
const { verifyAuth } = require("./middlewares/auth");

app.use(verifyAuth);

app.use("/api/payments/success", (req) => {
  console.log(req.body);
});

app.use("/api/users/", require("./users/routes"));
app.use("/api/schools/", require("./schools/routes"));
app.use("/api/link/", require("./link/routes"));
app.use("/api/courses", require("./courses/routes"));
app.use("/api/students", require("./students/routes"));
app.use("/api/payments", require("./payments/routes"));
app.use("/api/lessons", require("./lessons/routes"));
app.use("/api/timetables", require("./timetables/routes"));

app.use(() => console.log(404));

app.listen(port = process.env.app_port, async () => {
    console.log(`1 - server listening on port ${port}`);
    try {
        await db.connect();
        console.log("2 - connection to the database was successful");
    } catch (error) {
        console.log(error);
    }
});
