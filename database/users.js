const db = require("./main");

exports.create = async ({email, provider, providerData}) => {
    try {
        console.log({email, provider, providerData})
        const result = await db.query("INSERT INTO users (email, provider, providerData) VALUES ( $1, $2, $3 ) RETURNING *;", [ email, provider, providerData ]);
        return result.rows[0];
    } catch (error) {
        console.log("error.name : ", error.name);
        console.log("error.title : ", error.title);
        console.log("error.message : ", error.message);
        return error;
    };
};

exports.get = async (type, data) => {
    try {
        console.log(type, data)
        const result = await db.query(`SELECT * FROM users WHERE ${type} = $1;`, [ data ]);
        return {
            exists: !!result.rowCount,
            data: result.rows[0],
        };
    } catch (error) 
        console.log("error.name : ", error.name);
        console.log("error.title : ", error.title);
        console.log("error.message : ", error.message);
        return error;
    };
};
