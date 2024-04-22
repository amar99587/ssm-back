const db = require("../database/courses");

exports.create = async (req) => {
    try {
        return await db.create(req.body);
    } catch (error) {
        return error;
    }
};

exports.update = async (req) => {
    try {
        return await db.update(req.body);
    } catch (error) {
        return error;
    }
};

exports.search = async (req) => {
    try {
        return await db.search(req.body, req.query);
    } catch (error) {
        return error;
    }
};

exports.isPaid = async (req) => {
    try {
        return await db.isPaid(req.body, req.query);
    } catch (error) {
        return error;
    }
};

exports.get = {
    one: async (course) => {
        try {
            return await db.get.one(course);
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