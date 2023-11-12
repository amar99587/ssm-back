const db = require("./main");

exports.create = async (name) => {
    try {
        const result = await db.query("insert into schools (name) values ( $1 ) RETURNING code;", [ name ]);
        return result.rows[0];
    } catch (error) {
        return error;
    };
};

exports.link = {
    new: async (user, school, role, status) => {
        try {
            const result = await db.query("insert into users_schools (user_code, school_code, role, status) values ( $1, $2, $3, $4 ) RETURNING *;", [ user, school, role || "owner", status || "active" ]);
            return result.rows[0];
        } catch (error) {
            return error;
        };
    },
    get: async (user, school) => {
        try {
            const result = await db.query("select * from users_schools where user_code = $1 and school_code = $2;", [ user, school ]);
            return {
                exists: !!result.rowCount,
                data: result.rows[0],
            };
        } catch (error) {
            return error;
        };
    }
};

exports.get = {
    one: async (user, school) => {
        try {
            const result = await db.query(`
                SELECT json_build_object('school', schools.*, 'link', users_schools.*) FROM users
                INNER JOIN users_schools ON users.code = users_schools.user_code
                INNER JOIN schools ON users_schools.school_code = schools.code 
                where user_code = $1 and school_code = $2;
            `, [ user, school ]);
            const data = result.rows[0].json_build_object;
            return {...data.school, link: data.link};
        } catch (error) {
            return error;
        };
    },
    user: async (code) => {
        try {
            const result = await db.query(`
                SELECT json_build_object('school', schools.*, 'link', users_schools.*) FROM users
                INNER JOIN users_schools ON users.code = users_schools.user_code
                INNER JOIN schools ON users_schools.school_code = schools.code 
                where user_code = $1;
            `, [ code ]);
            const data = [];
            result.rows.forEach((i) => {data.push({...i.json_build_object.school, link: i.json_build_object.link});});
            return data;
        } catch (error) {
            return error;
        };
    }
};