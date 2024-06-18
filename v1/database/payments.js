const db = require("../../database");
const { search } = require("../utilities/db");
const { handleDbError } = require("../utilities/validator");

exports.create = async (payment, user) => {
    try {
        const result = await db.query("INSERT INTO payments (user_code, user_name, school, student, course, price, quantity, total) VALUES ( $1, $2, $3, $4, $5, $6, $7, $8 ) RETURNING *;", [ user.code, user.providerdata.name || "user", payment.school, payment.student, payment.course, payment.price, payment.quantity, payment.total ]);
        return result.rows[0];
    } catch (error) {
        return handleDbError(error);
    };
};

exports.search = async (payment, { offset, limit }) => {
    try {
        const result = await search({ select: 'p.*, c.name as course_name', table: "payments as p INNER JOIN courses c ON p.course = c.uid", where: { "p.student": payment.student }, exact: ["p.student"], toText: ["p.total"], toDate: ["p.created_at"], offset, limit }, db );
        return result.rows;
    } catch (error) {
        return handleDbError(error);
    };
};

exports.get = {
    one: async (payment) => {
        try {
            const result = await db.query("SELECT * FROM payments WHERE uid = $1;", [ payment ]);
            return result.rows[0];
        } catch (error) {
            return handleDbError(error);
        };
    },
    student: async (student) => {
        try {
            const result = await db.query("SELECT * FROM payments WHERE student = $1 ORDER BY created_at DESC;", [ student ]);
            return result.rows[0];
        } catch (error) {
            return handleDbError(error);
        };
    },
    school: async ({ school, from, to, user, course }) => {
        try {
            const result = await db.query(`
                SELECT p.*, c.name as course_name FROM payments as p
                INNER JOIN courses c ON p.course = c.uid 
                WHERE p.school = $1  
                AND p.created_at >= $2
                AND p.created_at <= $3
                AND p.user_name ILIKE $4
                AND c.name ILIKE $5
                ORDER BY p.created_at DESC;
            `, [ school, from + ":00", to + ":59", `%${user}%`, `%${course}%` ]);
            console.log(result.rows[0]);
            return result.rows;
        } catch (error) {
            return handleDbError(error);
        };
    }
};