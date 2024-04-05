const db = require("./main");
const { search } = require("../utilities/db");
const { handleDbError } = require("../utilities/validator");

exports.create = async (course) => {
    try {
        const result = await db.query("INSERT INTO courses (school, name, teacher, price) VALUES ( $1, $2, $3, $4 ) RETURNING *;", [ course.school, course.name, course.teacher, course.price ]);
        return result.rows[0];
    } catch (error) {
        return handleDbError(error);
    };
};

exports.update = async (course) => {
    try {
        const result = await db.query("UPDATE courses SET name = $1, teacher = $2, price = $3 WHERE uid = $4 RETURNING *;", [ course.name, course.teacher, course.price, course.uid ]);
        return result.rows[0];
    } catch (error) {
        return handleDbError(error);
    };
};

exports.search = async (course, {offset, limit}) => {
    try {
        const result = await search({table: "courses", where: course, exact: ["school"], toText: ["price"], offset: offset, limit: limit}, db);
        return result.rows;
    } catch (error) {
        return handleDbError(error);
    };
};

exports.isPaid = async ({student, school}, {offset = "0", limit = "20"}) => {
    try {
        const result = await db.query(`
            SELECT DISTINCT courses.*,
                CASE WHEN payments.student = $1 THEN TRUE ELSE FALSE END AS linked
            FROM courses
            LEFT JOIN payments ON payments.course = courses.uid AND payments.student = $1
            LEFT JOIN students ON payments.student = students.uid 
            WHERE courses.school = $2
            ORDER BY linked DESC OFFSET $3 LIMIT $4;
        `, [ student, school, offset, limit ]);
        // console.log(result.rows);
        return result.rows;
    } catch (error) {
        return handleDbError(error);
    };
};

exports.get = {
    one: async (course) => {
        try {
            const result = await db.query("SELECT * FROM courses WHERE uid = $1;", [ course ]);
            return result.rows[0];
        } catch (error) {
            return handleDbError(error);
        };
    },
    all: async (school) => {
        try {
            const result = await db.query("SELECT * FROM courses WHERE school = $1 ORDER BY created_at DESC;", [ school ]);
            return result.rows;
        } catch (error) {
            return handleDbError(error);
        };
    },
};