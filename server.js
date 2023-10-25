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

const users = require("./users/routes");
const OTP = require("./OTP/routes");

app.use(verifyAuth);

app.use("/api/users/", users);
app.use("/api/OTP/", OTP);

app.get("/", async (req, res) => {
    const result = await db.query(`select * from users`);
    const timestamp = result.rows[0].created_at;
    const convert = new Date(timestamp).getTime().toString();
    res.status(200).send(convert);
});

app.listen(port = process.env.app_port, async () => {
    console.log(`1 - server listening on port ${port}`);
    try {
        await db.connect();
        console.log("2 - connection to the database was successful");
    } catch (error) {
        console.log(error);
    }
});