const db = require("../database/timetables");

exports.create = async (req) => {
    try {
        return await db.create(req.body);
    } catch (error) {
        return error;
    }
};

exports.delete = async (uid) => {
    try {
        return await db.delete(uid);
    } catch (error) {
        return error;
    }
};

exports.get = async (school) => {
    try {
        return await db.get(school);
    } catch (error) {
        return error;
    }
};