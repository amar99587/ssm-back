const db = require("../../database");
const { handleDbError } = require("../utilities/validator");

exports.create = async () => {
    try {
        const result = await db.query("", );
        return result;
    } catch (error) {
        return handleDbError(error);
    };
};