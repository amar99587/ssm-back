const db = require("../../database");
const { toDate } = require("../utilities/date");
const { handleDbError } = require("../utilities/validator");

exports.create = async (payment, user) => {
    try {
        const result = await db.query("INSERT INTO payments (user_code, user_name, school, student, course, price, quantity, total) VALUES ( $1, $2, $3, $4, $5, $6, $7, $8 ) RETURNING *;", [ user.code, user.providerdata.name || "user", payment.school, payment.student, payment.course, payment.price, payment.quantity, payment.total ]);
        return result.rows[0];
    } catch (error) {
        return handleDbError(error);
    };
};

exports.search = async ({ student, course_name, total, created_at }, { offset, limit }) => {
    try {
        const result = await db.query(`
            SELECT p.*, c.name as course_name FROM payments as p 
            INNER JOIN courses c ON p.course = c.uid 
            WHERE p.student = $1 AND c.name ILIKE $2 AND p.total::text ILIKE $3 AND p.created_at::text ILIKE $4
            ORDER BY created_at DESC 
            OFFSET $5 LIMIT $6;
        `, [ student, `%${ course_name || '' }%`, `%${ total || '' }%`, `%${ created_at.length ? toDate(created_at) : '' }%`, offset || '0', limit || '20' ])
        console.log('result rows length : ', result.rows.length);
        return result.rows;
    } catch (error) {
        console.log(error);
        return handleDbError(error);
    };
};

exports.finance = async ({ school, from, to, user, course, teacher }, { offset = 0, limit = 20 }) => {
    console.log({ school, from, to, user, course, teacher, offset, limit });
    try {
        const filtered_payments = `
            SELECT 
                p.*, 
                c.name as course_name, 
                c.teacher as teacher_name 
            FROM payments as p
            INNER JOIN courses c ON p.course = c.uid 
            WHERE p.school = $1  
            AND p.created_at >= $2
            AND p.created_at <= $3
            AND p.user_code ILIKE $4
            AND c.name ILIKE $5
            AND c.teacher ILIKE $6
            ORDER BY p.created_at DESC
        `;
        const data = [ school, `${from}:00`, `${to}:59`, `%${ user || '' }%`, `%${ course || '' }%`, `%${ teacher || '' }%`  ];
        
        let statistic;
        if (!+offset) {
            statistic = await db.query(`
                WITH filtered_payments AS (${ filtered_payments })
                SELECT 
                    (SELECT SUM(total) FROM filtered_payments) AS recipe, 
                    (SELECT count(*) FROM filtered_payments) AS payments,
                    (SELECT SUM((price * quantity) - total) FROM filtered_payments WHERE (price * quantity) > total) AS discount,
                    (SELECT SUM(total) FROM filtered_payments WHERE total < 0) AS payback;
            `, data);
        }
        const list = await db.query(`${filtered_payments} OFFSET $7 LIMIT $8;`, [ ...data, +offset, limit ]);

        const result = {
            statistic: statistic?.rows[0],
            rows: list.rows
        };
        console.log(result);
        return result;
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
    school: async ({ school, from, to, user, course }, { offset, limit }) => {
        console.log({ school, from, to, user, course, offset, limit });
        try {
            const result = await db.query(`
                SELECT p.*, c.name as course_name FROM payments as p
                INNER JOIN courses c ON p.course = c.uid
                WHERE p.school = $1
                AND p.created_at >= $2
                AND p.created_at <= $3
                AND p.user_name ILIKE $4
                AND c.name ILIKE $5
                ORDER BY p.created_at DESC
                OFFSET $6 LIMIT $7;
            `, [ school, `${from}:00`, `${to}:59`, `%${ user || '' }%`, `%${ course || '' }%`, offset || '0', limit || '20'  ]);
            return result.rows;
        } catch (error) {
            return handleDbError(error);
        };
    }
};