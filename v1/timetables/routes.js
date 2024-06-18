const { Router } = require("express");
const timetable = require("./services");
const auth = require("../middlewares/auth");

const app = Router();

app.post("/create", auth.require, async (req, res) => {
    try {
        const result = await timetable.create(req);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

app.delete("/delete/:timetable", auth.require, async (req, res) => {
    try {
        const result = await timetable.delete(req.params.timetable);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

app.get("/get/:school", auth.require, async (req, res) => {
    try {
        const result = await timetable.get(req.params.school);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

module.exports = app; 