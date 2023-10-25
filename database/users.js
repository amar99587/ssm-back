const db = require("./main");

exports.createNewUser = async ({email, password}) => {
    try {
        const result = await db.query("insert into users (email, password) values ( $1, $2 ) RETURNING uid, code, email, created_at", [ email, password ]);
        return result;
    } catch (error) {
        return error;
    };
};

exports.getUserBy = {
    email: async (email) => {
        try {
            const result = await db.query(`select * from users where email = $1;`, [ email ]);
            return {
                exists: !!result.rowCount,
                data: result.rows[0],
            };
        } catch (error) {
            return error;
        };
    },
    uid: async (uid) => {
        try {
            const result = await db.query(`select * from users where uid = $1`, [ uid ]);
            return {
                exists: !!result.rowCount,
                data: result.rows[0],
            };
        } catch (error) {
            console.log(error);
            return error;
        };
    }
};

// exports.getUserSchool = async (userUid, schoolUid) => {
//     try {
//         const result = await db.query(`
//             SELECT schools.uid as uid, schools.name as name, schools.logo as logo, user_schools.role as role, schools.status as status
//             FROM users
//             INNER JOIN user_schools ON users.uid = user_schools.user_uid
//             INNER JOIN schools ON user_schools.school_uid = schools.uid 
//             where user_uid = $1 and school_uid = $2;
//         `, [ userUid, schoolUid ]);
//         return {
//             exists: !!result.rowCount,
//             data: result.rows[0],
//         };
//     } catch (error) {
//         console.log(error);
//         return error;
//     };
// };

// exports.getUserSchools = async (userUid) => {
//     try {
//         const result = await db.query(`
//             SELECT schools.uid as uid, schools.name as name, schools.logo as logo, user_schools.role as role, schools.status as status
//             FROM users
//             INNER JOIN user_schools ON users.uid = user_schools.user_uid
//             INNER JOIN schools ON user_schools.school_uid = schools.uid 
//             where user_uid = $1;
//         `, [ userUid ]);
//         return {
//             empty: !result.rowCount,
//             data: result.rows,
//         };
//     } catch (error) {
//         console.log(error);
//         return error;
//     };
// };