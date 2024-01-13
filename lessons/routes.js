const { Router } = require("express");
const lesson = require("./services");
const auth = require("../middlewares/auth");

const app = Router();

app.post("/create", auth.require, async (req, res) => {
    const result = await lesson.create(req);
    res.status(200).send(result);
});

app.post("/search", auth.require, async (req, res) => {
    const result = await lesson.search(req);
    console.log(result);
    res.status(200).send(result);
});

app.get("/get/:lesson", auth.require, async (req, res) => {
    const result = await lesson.get.one(req.params.lesson);
    res.status(200).send(result);
});

app.get("/get/student/:uid", auth.require, async (req, res) => {
    const result = await lesson.get.student(req.params.uid);
    console.log(result);
    res.status(200).send(result);
});

app.post("/get/students", auth.require, async (req, res) => {
    const result = await lesson.get.students(req.body);
    res.status(200).send(result);
});

app.post("/student/change/status", auth.require, async (req, res) => {
    const result = await lesson.changeStudentStatus(req.body);
    res.status(200).send(result);
});

module.exports = app; 