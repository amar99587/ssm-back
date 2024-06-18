const db = require("../database/schools");

const chargily_secret_key = process.env.chargily_secret_key;

exports.create = async (req) => {
  const { user, body } = req;
  try {
    const options = {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${chargily_secret_key}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        "currency": "dzd",
        "amount": body.subscription.price * body.subscription.duration,
        "success_url": `${process.env.cors_origin}/school/${body.school}`,
        "failure_url": `${process.env.cors_origin}/account?pay=canceled`,
        "webhook_endpoint": `https://api.proecole.com/v1/pay/webhook`,
        "metadata": {
          user,
          "school": body.school,
          "subscription": body.subscription,
          date: Date.now()
        }
      })
    };
    const response = await fetch('https://pay.chargily.net/test/api/v2/checkouts', options);
    const data = await response.json();
    // console.log('data : ', data);
    return data;
  } catch (error) {
    console.log(error);
    return error;
  }
};

exports.webhook = async (req) => {
  try {
    const { school, subscription } = req.body.data.metadata;
    const result = await db.update.subscription(school, +subscription.duration);
    return result;
  } catch (error) {
    console.log(error);
    return error;
  }
};

exports.check = async (id) => {
  try {
    const options = {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${chargily_secret_key}`,
        'Content-Type': 'application/json'
      }
    };
    const response = await fetch('https://pay.chargily.net/test/api/v2/checkouts/' + id, options);
    const data = await response.json();
    // console.log('data : ', data);
    return data;
  } catch (error) {
    console.log(error);
    return error;
  }
};