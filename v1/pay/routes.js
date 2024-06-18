const { Router } = require("express");
const pay = require("./services");
const auth = require("../middlewares/auth");

const app = Router();

app.post("/create", auth.require, async (req, res) => {
  try {
    const result = await pay.create(req);
    res.status(200).send(result);
  } catch (error) {
    console.log(error);
  }
});

app.post("/webhook", async (req, res) => {
  try {
    const result = await pay.webhook(req);
    console.log({
      type: req.body.type,
      webhook: req.body.id, 
      checkout: req.body.data.id
    });
    res.status(200);
  } catch (error) {
    console.log(error);
  }
});

app.get("/check/:id", async (req, res) => {
  try {
    const result = await pay.check(req.params.id);
    // console.log(result);
    res.status(200).send(result);
  } catch (error) {
    console.log(error);
  }
});

module.exports = app; 