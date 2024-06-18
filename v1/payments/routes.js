const { Router } = require("express");
const payment = require("./services");
// const email = require("../utilities/email");
const auth = require("../middlewares/auth");

const app = Router();

app.post("/create", auth.require, async (req, res) => {
    try {
        const result = await payment.create(req);
        //await email.send('payment', req.user.email, result);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

app.post("/search", auth.require, async (req, res) => {
    try {
        const result = await payment.search(req);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

app.post("/get/school", auth.require, async (req, res) => {
    try {
        const result = await payment.get.school(req.body);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

app.get("/get/:payment", auth.require, async (req, res) => {
    try {
        const result = await payment.get.one(req.params.payment);
        res.status(200).send(result);
    } catch (error) {
        console.log(error);
    }
});

module.exports = app; 