const db = require("../database/users");

exports.access = async (provider, data) => {
    try {
        const result = await db.get("email", data.email);
        if (result.exists) {
            return result.data;
        } else {
            const result = await db.create({ email: data.email, provider, providerData: data });
            return result;
        }
    } catch (error) {
        return error;
    }
};