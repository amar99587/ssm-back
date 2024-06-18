const { Router } = require("express");
const course = require("./services");
const auth = require("../middlewares/auth");

const app = Router();

app.post("/create", auth.require, async (req, res) => {
    try {
        const result = await course.create(req);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

app.post("/update", auth.require, async (req, res) => {
    try {
        const result = await course.update(req);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

app.get("/get/:course", auth.require, async (req, res) => {
    try {
        const result = await course.get.one(req.params.course);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

app.get("/get/all/:school", auth.require, async (req, res) => {
    // const enter = new Date();
    try {
        const result = await course.get.all(req.params.school);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
    // console.log("new-course", Date.now() - enter);
});

module.exports = app; 