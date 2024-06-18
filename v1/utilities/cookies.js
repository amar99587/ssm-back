const { sign, verify } = require("jsonwebtoken");

const jwtSecret = process.env.jwt_secret_key;

exports.options = maxAge => `Max-Age=${ maxAge * 1000 }; HttpOnly; Path=/; ${ process.env.app_env == 'production' || process.env.app_env == 'hosted-development' ? 'SameSite=None; Secure; Partitioned;' : '' }`

exports.create = (cookieName, data, CustomMaxAge) => {
    const maxAge = CustomMaxAge == undefined ? (30 * 24 * 60 * 60) : CustomMaxAge; //  default value : 30 days in seconds
    const token = sign(data, jwtSecret, { expiresIn: maxAge });
    return `${cookieName}=${token}; ${exports.options(maxAge)}`;
};

exports.read = (token = false) => {
    return token && new Promise((resolve, reject) => {
        verify(String(token), jwtSecret, (error, data) => error ? reject(error) : resolve(data));
    });
};