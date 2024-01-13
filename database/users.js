const db = require("./main");

exports.create = async ({email, password}) => {
    try {
        const result = await db.query("INSERT INTO users (email, password) VALUES ( $1, $2 ) RETURNING code, email, created_at;", [ email, password ]);
        return result;
    } catch (error) {
        return error;
    };
};

exports.get = async (type, data) => {
    try {
        const result = await db.query(`SELECT * FROM users WHERE ${type} = $1;`, [ data ]);
        return {
            exists: !!result.rowCount,
            data: result.rows[0],
        };
    } catch (error) {
        return error;
    };
};