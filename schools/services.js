const db = require("../database/schools");

exports.create = async (req) => {
    try {
        const school = await db.create(req.body);
        const link = await db.link.new(req.user.code, school.code);
        return link;
    } catch (error) {
        return error;
    }
};

exports.get = {
    one: async (user_code, school_code) => {
        try {
            const result = await db.get.one(user_code, school_code);
            return result;
        } catch (error) {
            return error;
        }
    },
    exact: async (code) => {
        try {
            const result = await db.get.exact(code);
            return result;
        } catch (error) {
            return error;
        }
    },
    user: async (code) => {
        try {
            return await db.get.user(code);
        } catch (error) {
            return error;
        }
    }
};