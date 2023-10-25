const db = require("./main");

exports.getSchoolBy = {
    uid: async (schoolUid) => {
        try {
            const result = await db.query(`select * from schools where uid = $1`, [ schoolUid ]);
            return {
                exists: !!result.rowCount,
                data: result.rows[0],
            };
        } catch (error) {
            return error;
        };
    }
};