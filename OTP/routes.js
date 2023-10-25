const { Router } = require("express");
const user = require("../users/services");
const auth = require("../middlewares/auth");
const cookies = require("../utilities/cookies");
const email = require("../utilities/email");
const { newError, resError } = require("../utilities/error");
const { avalide, generateOTP } = require("../utilities/validator");

const app = Router();

app.post("/send", auth.refuse, async (req, res) => {
    try {
        const data = req.body;
        if (avalide.email(data.email)) {
            const OTP = generateOTP();
            console.log({OTP, ...data});
            await email.send.OTP(data.email, OTP);
            const { token, defaultValue } = cookies.create({...data, OTP}, 30 * 60);
            res.cookie("cookie", token, defaultValue);
            res.sendStatus(200);
        } else {
            newError("email is not valid");
        }
    } catch (error) {
        resError(res, error);
    };
});

app.post('/verify/signup', auth.refuse, async (req, res) => {
    try {
        const data = await cookies.read(req.cookies.cookie);
        if (data.OTP == req.body.OTP) {
            delete data.OTP;
            const result = await user.signup(data);
            if (result.exists) {
                newError("the email you entered is already in use");
            } else {
                const { token, defaultValue } = cookies.create(result);
                res.cookie("cookie", token, defaultValue);
                console.log(token);
                res.status(200).send(result);
            }
        } else {
            newError("OTP is not correct");
        }
    } catch (error) {
        console.log(error.message);
        resError(res, error);
    };
});

app.post('/verify/login', auth.refuse, async (req, res) => {
    try {
        const data = await cookies.read(req.cookies.cookie);
        if (data.OTP == req.body.OTP) {
            delete data.OTP;
            const result = await user.login(data);
            console.log(result);
            if (result.exists && result.matched) {
                const { token, defaultValue } = cookies.create(result.data);
                res.cookie("cookie", token, defaultValue );
                res.status(200).send(result.data);
            } else {
                newError(result.exists ? "password is not correct" : "undefined user");
            }
        } else {
            newError("OTP is not correct");
        }
    } catch (error) {
        resError(res, error);
    };
});

module.exports = app;