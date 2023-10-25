const { sign, verify } = require("jsonwebtoken");

const jwtSecret = process.env.jwt_secret_key;

exports.create = (data, CustomMaxAge) => {
    const maxAge = CustomMaxAge || (30 * 24 * 60 * 60); //  default value : 30 days in seconds
    const token = sign(data, jwtSecret, { expiresIn: maxAge });
    return { token, defaultValue: { httpsOnly: true, maxAge: maxAge * 1000 } };
};

exports.read = (token = false) => {
    return token && new Promise((resolve, reject) => {
        verify(String(token), jwtSecret, (error, data) => error ? reject(error) : resolve(data));
    });
};
