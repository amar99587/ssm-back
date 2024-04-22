const db = require("../database/students");

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
            return await db.get.one(course);
        } catch (error) {
            return error;
        }
    },
};