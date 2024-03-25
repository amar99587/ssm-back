const db = require("../database/timetables");

exports.create = async (req) => {
    try {
        const result = await db.create(req.body);
        return result;
    } catch (error) {
        return error;
    }
};

exports.delete = async (uid) => {
    try {
        const result = await db.delete(uid);
        return result;
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