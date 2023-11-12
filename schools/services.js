const db_school = require("../database/schools");

exports.create = async (req) => {
    try {
        const school = await db_school.create(req.body.name);
        const link = await db_school.link.new(req.user.code, school.code);
        return link;
    } catch (error) {
        return error;
    }
};

exports.get = {
    one: async (user_code, school_code) => {
        try {
            const result = await db_school.get.one(user_code, school_code);
            return result;
        } catch (error) {
            return error;
        }
    },
    user: async (code) => {
        try {
            return await db_school.get.user(code);
        } catch (error) {
            return error;
        }
    }
};