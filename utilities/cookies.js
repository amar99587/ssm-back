const { sign, verify } = require("jsonwebtoken");

const jwtSecret = process.env.jwt_secret_key;

exports.options = (maxAge) => { 
    return { sameSite: 'none', secure: true, httpOnly: true, maxAge: maxAge * 1000 };
    // return { httpOnly: true, maxAge: maxAge * 1000 };
}; 

exports.create = (data, CustomMaxAge) => {
    const maxAge = CustomMaxAge || (30 * 24 * 60 * 60); //  default value : 30 days in seconds
    const token = sign(data, jwtSecret, { expiresIn: maxAge });
    return { token, defaultValue: exports.options(maxAge) };
};

exports.read = (token = false) => {
    return token && new Promise((resolve, reject) => {
        verify(String(token), jwtSecret, (error, data) => error ? reject(error) : resolve(data));
    });
};
