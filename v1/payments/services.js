const db = require("../database/payments");

exports.create = async (req) => {
    try {
        return await db.create(req.body, req.user);
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
    one: async (payment) => {
        try {
            return await db.get.one(payment);
        } catch (error) {
            return error;
        }
    },
    school: async (req) => {
        try {
            console.log(req.query);
            return await db.finance(req.body, req.query);
        } catch (error) {
            console.log(error);
            return error;
        }
    },
};