const db = require("../database/subscriptions");
const { create: createSchool } = require('../schools/services');
const { toDate } = require("../utilities/date");

const chargily_secret_key = process.env.chargily_secret_key;
const live = chargily_secret_key.startsWith("live");

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
        "amount": (body.subscription.price * body.subscription.duration),
        "success_url": `${process.env.cors_origin}/${body.school ? `school/${body.school}` : 'account'}`,
        "failure_url": `${process.env.cors_origin}/account?pay=canceled`,
        "webhook_endpoint": `${process.env.app_origin}/v1/subscriptions/webhook`,
        "metadata": {
          user,
          "school": body.school,
          "name": body.name,
          "newSchool": !body.school,
          "subscription": body.subscription,
          date: Date.now()
        }
      })
    };
    const response = await fetch(`https://pay.chargily.net${ live ? '/' : '/test/' }api/v2/checkouts`, options);
    const data = await response.json();
    return data;
  } catch (error) {
    console.log(error);
    return error;
  }
};

exports.webhook = async (req) => {
  try {
    const checkout = {
      id: req.body.data.id,
      ...req.body.data.metadata,
      amount: req.body.data.amount,
      exists: await db.exist(req.body.data.id),
    };
    console.log(`does checkout exists => ${checkout.exists}`);
    if (checkout.exists) {
      const { school } = await db.get(checkout.id);
      return {
        exists: true,
        school,
        message: `checkout ${checkout.id} already exists`
      };
    } else {
      if (checkout.newSchool) {
        const school = await createSchool({ 
          body: { 
            name: checkout.name, 
            email: checkout.user.email, 
            license_end: toDate(Date.now() + (1000 * 60 * 60 * 24 * 30 * checkout.subscription.duration), 'timestamp')
          }, 
          user: checkout.user 
        });
        const createSub = await db.create({ ...checkout, school: school.school_code });
        const updateSub = await db.update.duration({ ...checkout, school: school.school_code });
        return { school, createSub, updateSub };
      } else {
        const createSub = await db.create(checkout);
        const updateSub = await db.update.duration(checkout);
        return { createSub, updateSub };
      }
    }
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
    const response = await fetch(`https://pay.chargily.net${ live ? '/' : '/test/' }api/v2/checkouts/${id}`, options);
    const data = await response.json();
    if (data.status == 'paid') {
      var result = await this.webhook({ body: { data } });
    }
    return { create: data.status == 'paid' && result, data };
  } catch (error) {
    console.log(error);
    return error;
  }
};