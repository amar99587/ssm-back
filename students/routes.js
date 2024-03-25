const { Router } = require("express");
const student = require("./services");
const auth = require("../middlewares/auth");

const app = Router();

app.post("/create", auth.require, async (req, res) => {
    const result = await student.create(req);
    res.status(200).send(result);
});

app.post("/update", auth.require, async (req, res) => {
    const result = await student.update(req);
    res.status(200).send(result);
});

app.post("/search", auth.require, async (req, res) => {
    const result = await student.search(req);
    res.status(200).send(result);
});

// app.get("/get/all/:school", auth.require, async (req, res) => {
//     const result = await student.get.all(req.params.school, req.query);
//     res.status(200).send(result);
// });

app.get("/get/:student", auth.require, async (req, res) => {
    // const enter = new Date();
    const result = await student.get.one(req.params.student);
    res.status(200).send(result);
    // console.log("student", Date.now() - enter);
});

module.exports = app; 