const { Router } = require("express");
const school = require("./services");
const auth = require("../middlewares/auth");

const app = Router();

app.post("/create", auth.require, async (req, res) => {
    try {
        const result = await school.create(req);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

app.get("/user", auth.require, async (req, res) => {
    try {
        const result = await school.get.user_schools(req.user.code);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

app.get("/get/:school", auth.require, async (req, res) => {
    try {
        const result = await school.get.one(req.user.code, req.params.school);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

app.post("/update", auth.require, async (req, res) => {
    try {
        const result = await school.update(req.body);
        // console.log(result);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

app.get("/get/all/users/:school", auth.require, async (req, res) => {
    try {
        const result = await school.get.school_users(req.params.school);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

module.exports = app; 