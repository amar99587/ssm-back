const db = require("../database/schools");
const dbLink = require("../database/link");

exports.create = async (req) => {
    try {
        const school = await db.create(req.body);
        const link = await dbLink.new({
            user: req.user.code,
            school: school.code,
            rules: require("../utilities/school-rules.json"),
            type: "owner", 
            status: "active"
        });
        return link;
    } catch (error) {
        return error;
    }
};

exports.get = {
    one: async (user, school) => {
        try {
            return await db.get.one(user, school);
        } catch (error) {
            return error;
        }
    },
    user_schools: async (code) => {
        try {
            return await db.get.user_schools(code);
        } catch (error) {
            return error;
        }
    },
    school_users: async (code) => {
        try {
            return await db.get.school_users(code);
        } catch (error) {
            return error;
        }
    }
};