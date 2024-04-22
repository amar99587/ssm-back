const db = require("../database/users");

exports.access = async (provider, data) => {
    try {
        const user = await db.get("email", data.email);
        if (user.exists) {
            return user.data;
        } else {
            return await db.create({ email: data.email, provider, providerData: data });
        }
    } catch (error) {
        return error;
    }
};