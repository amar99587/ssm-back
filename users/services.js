const { genSalt, hash, compare } = require("bcrypt");
const db_user = require("../database/users");

exports.signup = async (data) => {
    try {
        const result = await db_user.get("email", data.email);
        if (result.exists) {
            return result;
        } else {
            const salt = await genSalt();
            data.password = await hash(data.password, salt);
            const result = await db_user.new(data);
            return result.rows[0];
        }
    } catch (error) {
        return error;
    }
};

exports.login = async ({email, password}) => {
    try {
        const result = await db_user.get("email", email);
        if (result.exists) {
            const matched = await compare(password, result.data.password);
            delete result.data.password;
            return matched ? { ...result, matched } : { exists: result.exists, matched };
        } else {
            return result;
        };
    } catch (error) {
        return error;
    }
};