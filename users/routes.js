const { Router } = require("express");
const auth = require("../middlewares/auth");
const cookies = require("../utilities/cookies");

const app = Router();

app.get("/enter", async (req, res) => {
    res.status(200).send(req.user);
});

app.get("/logout", auth.require, async (req, res) => {
    res.cookie("cookie", "", { defaultValue: cookies.options(0) });
    res.sendStatus(200);
});

module.exports = app; 