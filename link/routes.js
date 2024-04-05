const { Router } = require("express");
const link = require("./services");
const auth = require("../middlewares/auth");

const app = Router();

app.post("/new", auth.require, async (req, res) => {
    const result = await link.new(req);
    console.log(result);
    res.status(200).send(result);
});

app.get("/:user/:school", auth.require, async (req, res) => {
    const result = await link.get(req);
    console.log(result);
    res.status(200).send(result);
});

app.post("/:user/:school", auth.require, async (req, res) => {
    const result = await link.update(req);
    console.log(result);
    res.status(200).send(result);
});

app.delete("/:user/:school", auth.require, async (req, res) => {
    const result = await link.delete(req);
    console.log(result);
    res.status(200).send(result);
});

module.exports = app; 