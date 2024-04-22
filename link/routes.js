const { Router } = require("express");
const link = require("./services");
const auth = require("../middlewares/auth");

const app = Router();

app.post("/new", auth.require, async (req, res) => {
    try {
        const result = await link.new(req);
        // console.log(result);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

app.get("/:user/:school", auth.require, async (req, res) => {
    try {
        const result = await link.get(req);
        // console.log(result);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

app.post("/:user/:school", auth.require, async (req, res) => {
    try {
        const result = await link.update(req);
        // console.log(result);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

app.delete("/:user/:school", auth.require, async (req, res) => {
    try {
        const result = await link.delete(req);
        // console.log(result);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

module.exports = app; 