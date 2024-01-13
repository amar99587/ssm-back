const db = require("../database/lessons");

exports.create = async (req) => {
    try {
        return await db.create(req.body);
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
    student: async (uid) => {
        try {
            return await db.get.student(uid);
        } catch (error) {
            return error;
        }
    },
    students: async (data) => {
        try {
            return await db.get.students(data);
        } catch (error) {
            return error;
        }
    },
};

exports.changeStudentStatus = async ({ lesson, student, present }) => {
    try {
        return await db.changeStudentStatus(lesson, student, !present);
    } catch (error) {
        return error;
    }
};