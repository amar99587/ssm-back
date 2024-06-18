const { Router, json } = require("express");
const cors = require("cors");
const cookies = require("cookie-parser");
const rateLimit = require("express-rate-limit");
const { verifyAuth } = require("./middlewares/auth");

const app = Router();

app.use(json());
app.use(cors({
  origin: process.env.cors_origin,
  credentials: true
}));
app.use(cookies());

// Apply middleware
app.use(verifyAuth);

// Apply limiter
// app.use(rateLimit({
//   windowMs: 10 * 60 * 1000, // 10 minutes
//   max: 300, // limit each IP to 300 requests per windowMs
//   message: "Too many requests from this IP, please try again after 10 minutes",
//   handler: (req, res) => {
//     console.log(`Rate limit exceeded for IP: ${req.ip}`);
//     res.status(429).send('Too many requests, please try again later.');
//   }
// }));

// Add routes
app.use("/users/", require("./users/routes"));
app.use("/schools/", require("./schools/routes"));
app.use("/link/", require("./link/routes"));
app.use("/courses", require("./courses/routes"));
app.use("/students", require("./students/routes"));
app.use("/payments", require("./payments/routes"));
app.use("/lessons", require("./lessons/routes"));
app.use("/timetables", require("./timetables/routes"));
app.use("/pay", require("./pay/routes"));

module.exports = app;