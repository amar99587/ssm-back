const db = require("./main");

exports.create = async ({name, email}) => {
    try {
        const result = await db.query("INSERT INTO schools (name, email) VALUES ( $1, $2 ) RETURNING code;", [ name, email ]);
        return result.rows[0];
    } catch (error) {
        return error;
    };
};

exports.link = {
    new: async (user, school, role, status) => {
        try {
            const result = await db.query("INSERT INTO users_schools (user_code, school_code, role, status) VALUES ( $1, $2, $3, $4 ) RETURNING *;", [ user, school, role || "owner", status || "active" ]);
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
                SELECT s.*, json_build_object('role', us.role, 'status', us.status, 'created_at', us.created_at AT TIME ZONE 'UTC') AS link 
                FROM users_schools us
                LEFT JOIN schools s ON us.school_code = s.code
                WHERE us.user_code = $1 AND school_code = $2;
            `, [ user, school ]);
            return result.rows[0];
        } catch (error) {
            return error;
        };
    },
    exact: async (code) => {
        try {
            const result = await db.query('SELECT created_at FROM schools WHERE code = $1;', [ code ]);
            const r2 = await db.query("SELECT json_build_object('created_at', created_at) FROM schools WHERE code = $1;", [ code ]);
            const data = result.rows[0];
            console.log(data.created_at, r2.rows[0].json_build_object.created_at);
            return { r1: data.created_at, r2: r2.rows[0].json_build_object.created_at };
        } catch (error) {
            return error;
        };
    },
    user: async (code) => {
        try {
            const result = await db.query(`
                SELECT s.*, json_build_object('role', us.role, 'status', us.status, 'created_at', us.created_at AT TIME ZONE 'UTC') AS link 
                FROM users_schools us
                LEFT JOIN schools s ON us.school_code = s.code
                WHERE us.user_code = $1 
                ORDER BY s.created_at DESC;
            `, [ code ]);
            return result.rows;
        } catch (error) {
            return error;
        };
    }
};