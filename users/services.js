const { genSalt, hash, compare } = require("bcrypt");
const { getUserBy, createNewUser } = require("../database/users");

exports.signup = async (data) => {
    try {
        const user = await getUserBy.email(data.email);
        if (user.exists) {
            return user;
        } else {
            const salt = await genSalt();
            data.password = await hash(data.password, salt);
            const result = await createNewUser(data);
            console.log(result.rows[0]);
            return result.rows[0];
        }
    } catch (error) {
        return error;
    }
};

exports.login = async ({email, password}) => {
    try {
        const user = await getUserBy.email(email);
        if (user.exists) {
            const matched = await compare(password, user.data.password);
            delete user.data.password;
            return matched ? { ...user, matched } : { exists: user.exists, matched };
        } else {
            return user;
        };
    } catch (error) {
        return error;
    }
};