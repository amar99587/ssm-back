const db = require("./main");
const { search } = require("../utilities/db");

exports.create = async (student) => {
    try {
        const result = await db.query("INSERT INTO students (school, name, birthday, email, phone) VALUES ( $1, $2, $3, $4, $5 ) RETURNING *;", [student.school, student.name, student.birthday, student.email, student.phone]);
        return result.rows[0];
    } catch (error) {
        return error;
    };
};

exports.update = async (student) => {
    try {
        const result = await db.query("UPDATE students SET name = $1, birthday = $2, email = $3, phone = $4 WHERE uid = $5 RETURNING *;", [student.name, student.birthday, student.email, student.phone, student.uid]);
        return result.rows[0];
    } catch (error) {
        return error;
    };
};

exports.search = async (student, {offset, limit}) => {
    try {
        const result = await search({table: "students", where: student, exact: ["school"], offset: offset, limit: limit}, db);
        // console.log(result.rows.length);
        return result.rows;
    } catch (error) {
        return error;
    };
};

exports.get = {
    // all: async (school, { offset, limit }) => {
    //     try {
    //         const query = {
    //             santex: `SELECT * FROM students WHERE school = $1 ORDER BY created_at DESC ${Number(offset) ? 'OFFSET $3' : ''} LIMIT $2;`, 
    //             values: [school, limit, offset]
    //         }
    //         console.log(query.santex, query.values);
    //         const result = await db.query(query.santex, query.values);
    //         return result.rows;
    //     } catch (error) {
    //         return error;
    //     };
    // },
    one: async (student) => {
        try {
            const result = await db.query("SELECT * FROM students WHERE uid = $1;", [student]);
            return result.rows[0];
        } catch (error) {
            return error;
        };
    }
};