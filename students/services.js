const db = require("../database/students");

exports.create = async (req) => {
    try {
        const result = await db.create(req.body);
        return result;
    } catch (error) {
        return error;
    }
};

exports.update = async (req) => {
    try {
        const result = await db.update(req.body);
        return result;
    } catch (error) {
        return error;
    }
};

exports.search = async (req) => {
    try {
        const result = await db.search(req.body, req.query);
        return result;
    } catch (error) {
        return error;
    }
};

exports.get = {
    // all: async (school, query) => {
    //     try {
    //         return await db.get.all(school, query);
    //     } catch (error) {
    //         return error;
    //     }
    // },
    one: async (course) => {
        try {
            const result = await db.get.one(course);
            return result;
        } catch (error) {
            return error;
        }
    },
};