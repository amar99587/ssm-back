const db = require("../../database");
const { handleDbError } = require("../utilities/validator");

exports.create = async ({ name, email, license_end }) => {
    console.log({ name, email, license_end });
    try {
        const result = await db.query(
            `INSERT INTO schools (name, email, license_end) VALUES ( ${ license_end ? '$1, $2, $3' : '$1, $2' } ) RETURNING code;`, 
            [ name, email, license_end ]
        );
        return result.rows[0];
    } catch (error) {
        console.log(error);
        return handleDbError(error);
    };
};

exports.update = async ({ school, name }) => {
    try {
        const result = await db.query("UPDATE schools SET name = $2 WHERE code = $1;", [ school, name ]);
        // console.log(result);
        return result.rows[0];
    } catch (error) {
        return handleDbError(error);
    };
};

exports.get = {
    one: async (user, school) => {
        try {
            user = user.toLowerCase();
            school = school.toLowerCase();
            const result = await db.query(`
                SELECT s.*, json_build_object('type', us.type, 'rules', us.rules, 'status', us.status, 'created_at', us.created_at AT TIME ZONE 'UTC') AS link 
                FROM users_schools us
                LEFT JOIN schools s ON us.school_code = s.code
                WHERE us.user_code = $1 AND school_code = $2;
            `, [user, school]);
            // console.log(result);
            return {
                haveAccess: result.rows.length,
                school: result.rows[0]
            };
        } catch (error) {
            return handleDbError(error);
        };
    },
    user_schools: async (code) => {
        try {
            code = code.toLowerCase();
            const result = await db.query(`
                SELECT 
                    s.code, s.name, s.license_end,
                    us.*
                FROM users_schools us
                LEFT JOIN schools s ON us.school_code = s.code
                WHERE us.user_code = $1 AND (us.status = 'active' OR (us.status = 'inactive' AND us.rules = '{}' ))
                ORDER BY us.created_at DESC;
            `, [code]);
            // console.log(result.rows[0]);
            return result.rows;
        } catch (error) {
            return handleDbError(error);
        };
    },
    school_users: async (code) => {
        try {
            code = code.toLowerCase();
            const result = await db.query(`
                SELECT us.user_code AS code, us.type, us.status, 
                    CASE WHEN us.status = 'active' THEN u.providerdata 
                    ELSE NULL 
                    END AS data
                FROM users_schools us
                LEFT JOIN users u ON us.user_code = u.code
                WHERE us.school_code = $1 AND (us.status = 'active' OR (us.status = 'inactive' AND us.rules <> '{}' ))
                ORDER BY us.created_at DESC;
            `, [code]);
            return result.rows;
        } catch (error) {
            return handleDbError(error);
        };
    }
};