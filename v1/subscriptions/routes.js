const { Router } = require("express");
const subscriptions = require("./services");
const auth = require("../middlewares/auth");

const app = Router();

app.post("/create", auth.require, async (req, res) => {
  try {
    const result = await subscriptions.create(req);
    res.status(200).send(result);
  } catch (error) {
    console.log(error);
  }
});

app.post("/webhook", async (req, res) => {
  try {
    console.log({
      type: req.body.type,
      webhook: req.body.id, 
      checkout: req.body.data.id,
      customer: req.body.data.customer_id,
    });
    if (req.body.type == 'checkout.paid') {
      var result = await subscriptions.webhook(req);
      console.log(result);
    }
    res.status(200).send(result);
  } catch (error) {
    console.log(error);
  }
});

app.get("/check/:id", async (req, res) => {
  try {
    const result = await subscriptions.check(req.params.id);
    console.log(result);
    res.status(200).send(result);
  } catch (error) {
    console.log(error);
  }
});

module.exports = app;