const { Router } = require("express");
const auth = require("../middlewares/auth");
const cookies = require("../utilities/cookies");
const user = require("./services");
const axios = require('axios');

const app = Router();

app.get("/login/:provider/:token", async (req, res) => {
    try {
        let response;
        switch (req.params.provider) {
            case 'google':
                response = await axios.get('https://www.googleapis.com/oauth2/v1/userinfo', {
                    headers: {
                        Authorization: `Bearer ${req.params.token}`
                    }
                });
                break;
        }
        if (response.status == 200) {
            const result = await user.access(req.params.provider, response.data);
            const cookie = cookies.create('cookie', result);
            res.setHeader('Set-Cookie', cookie);
            res.status(200).send(result);
        } else {
            throw new Error(response);
        }
    } catch (error) {
        console.log(error.name, error.message);
    }
});

app.get("/enter", async (req, res) => {
    res.status(200).send(req.user);
});

app.get("/logout", auth.require, async (req, res) => {
    res.cookie("cookie", "", { defaultValue: cookies.options(0) });
    res.sendStatus(200);
});

module.exports = app; 