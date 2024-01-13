const db = require("../database/courses");

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

exports.isPaid = async (req) => {
    try {
        const result = await db.isPaid(req.body, req.query);
        return result;
    } catch (error) {
        return error;
    }
};

exports.get = {
    one: async (course) => {
        try {
            const result = await db.get.one(course);
            return result;
        } catch (error) {
            return error;
        }
    },
    all: async (school) => {
        try {
            return await db.get.all(school);
        } catch (error) {
            return error;
        }
    },
};