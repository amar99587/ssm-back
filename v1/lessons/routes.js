const { Router } = require("express");
const lesson = require("./services");
const auth = require("../middlewares/auth");

const app = Router();

app.post("/create", auth.require, async (req, res) => {
    try {
        const result = await lesson.create(req);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

app.post("/search", auth.require, async (req, res) => {
    try {
        const result = await lesson.search(req);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

app.get("/get/:lesson", auth.require, async (req, res) => {
    try {
        const result = await lesson.get.one(req.params.lesson);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

app.get("/get/student/:uid", auth.require, async (req, res) => {
    try {
        const result = await lesson.get.student(req.params.uid);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

app.post("/get/students", auth.require, async (req, res) => {
    try {
        const result = await lesson.get.students(req.body);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

app.post("/student/change/status", auth.require, async (req, res) => {
    try {
        const result = await lesson.changeStudentStatus(req.body);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

module.exports = app; 