const cookies = require("../utilities/cookies");

exports.compareOTPs = async (req) => {
    try {
        const cookie = await cookies.read(req.cookies.cookie);
        const data = req.body;
        console.log(cookie.OTP == data.OTP);
        return cookie.OTP == data.OTP;
    } catch (error) {
        return error;
    };
};