const { Router } = require("express");
const school = require("./services");
const auth = require("../middlewares/auth");

const app = Router();

app.post("/create", auth.require, async (req, res) => {
    const result = await school.create(req);
    res.status(200).send(result);
});

app.get("/user", auth.require, async (req, res) => {
    const result = await school.get.user(req.user.code);
    res.status(200).send(result);
});

app.get("/get/:code", auth.require, async (req, res) => {
    const result = await school.get.one(req.user.code, req.params.code);
    console.log(result);
    res.status(200).send(result);
});

app.get("/get/exact/:code", async (req, res) => {
    const result = await school.get.exact(req.params.code);
    res.status(200).send(result);
});

module.exports = app; 