const { Router } = require("express");
const school = require("./services");
const auth = require("../middlewares/auth");

const app = Router();

app.post("/create", auth.require, async (req, res) => {
    const result = await school.create(req);
    res.status(200).send(result);
});

app.get("/user", auth.require, async (req, res) => {
    const result = await school.get.user_schools(req.user.code);
    res.status(200).send(result);
});

app.get("/get/:school", auth.require, async (req, res) => {
    const result = await school.get.one(req.user.code, req.params.school);
    res.status(200).send(result);
});

app.get("/get/all/users/:school", auth.require, async (req, res) => {
    const result = await school.get.school_users(req.params.school);
    res.status(200).send(result);
});

module.exports = app; 