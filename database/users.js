const db = require("./main");

exports.create = async ({email, provider, providerData}) => {
    try {
        const result = await db.query("INSERT INTO users (email, provider, providerData) VALUES ( $1, $2, $3 ) RETURNING *;", [ email, provider, providerData ]);
        return result.rows[0];
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