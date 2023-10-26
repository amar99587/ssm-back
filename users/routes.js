const { Router } = require("express");
// const user = require("./services");
const cookies = require("../utilities/cookies");
const auth = require("../middlewares/auth");

const app = Router();

app.get("/enter", async (req, res) => {
    res.status(200).send(req.user);
});

app.get("/logout", auth.require, async (req, res) => {
    res.cookie("cookie", "", ...cookies.options({ maxAge: 0 }) );
    res.sendStatus(200);
});

module.exports = app;
