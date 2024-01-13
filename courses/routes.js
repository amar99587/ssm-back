const { Router } = require("express");
const course = require("./services");
const auth = require("../middlewares/auth");

const app = Router();

app.post("/create", auth.require, async (req, res) => {
    const result = await course.create(req);
    res.status(200).send(result);
});

app.post("/update", auth.require, async (req, res) => {
    const result = await course.update(req);
    res.status(200).send(result);
});

// app.post("/search", auth.require, async (req, res) => {
//     const enter = new Date();
//     const result = await course.search(req);
//     res.status(200).send(result);
//     console.log("old-course", Date.now() - enter);
// });

// app.post("/isPaid", auth.require, async (req, res) => {
//     const enter = new Date();
//     const result = await course.isPaid(req);
//     res.status(200).send(result);
//     console.log("old-course", Date.now() - enter);
// });

app.get("/get/:course", auth.require, async (req, res) => {
    const result = await course.get.one(req.params.course);
    res.status(200).send(result);
});

app.get("/get/all/:school", auth.require, async (req, res) => {
    // const enter = new Date();
    const result = await course.get.all(req.params.school);
    res.status(200).send(result);
    // console.log("new-course", Date.now() - enter);
});

module.exports = app; 