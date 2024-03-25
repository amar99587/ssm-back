const db = require("./main");
const { search } = require("../utilities/db");

exports.create = async (payment, user) => {
    try {
        const result = await db.query("INSERT INTO payments (user_code, user_name, school, student, course, course_name, price, quantity, total) VALUES ( $1, $2, $3, $4, $5, $6, $7, $8, $9 ) RETURNING *;", [ user.code, user.email.split("@")[0], payment.school, payment.student, payment.course, payment.course_name, payment.price, payment.quantity, payment.total ]);
        return result.rows[0];
    } catch (error) {
        return error;
    };
};

exports.search = async (payment, {offset, limit}) => {
    try {
        const result = await search({table: "payments", where: payment, exact: ["student"], toText: ["total"], toDate: ["created_at"], offset: offset, limit: limit}, db);
        return result.rows;
    } catch (error) {
        return error;
    };
};

exports.get = {
    one: async (payment) => {
        try {
            const result = await db.query("SELECT * FROM payments WHERE uid = $1;", [ payment ]);
            return result.rows[0];
        } catch (error) {
            return error;
        };
    },
    student: async (student) => {
        try {
            const result = await db.query("SELECT * FROM payments WHERE student = $1 ORDER BY created_at DESC;", [ student ]);
            return result.rows[0];
        } catch (error) {
            return error;
        };
    },
    school: async ({ school, from, to, user, course }) => {
        try {
            const result = await db.query(`
                SELECT * FROM payments 
                WHERE 
                school = $1  
                AND created_at >= $2
                AND created_at <= $3
                AND user_name ILIKE $4
                AND course_name ILIKE $5
                ORDER BY created_at DESC;
            `, [ school, from + ":00", to + ":59", `%${user}%`, `%${course}%` ]);
            return result.rows;
        } catch (error) {
            return error;
        };
    }
};