const db = require("../database/schools");
const dbLink = require("../database/link");
const { toDate } = require("../utilities/date");

exports.create = async (req) => {
    try {
        const school = await db.create({
            email: req.user.email, 
            name: req.body.name,
            license_end: toDate(Date.now() + (1000 * 60 * 60 * 24 * 30), 'timestamp')
        });
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
}

exports.update = async data => {
    console.log(data);
    try {
        let result;
        if (data.school.length == 11 && data.name.length >= 1) {
            result = await db.update(data);
        } else {
            result = { message: `school name is ${data.name.length < 1 ? 'too short' : 'requird'}, check the data`, data };
        }
        return result;
    } catch (error) {
        console.log(error);
        return error;
    }
};

exports.get = {
    one: async (user, school) => {
        try {
            let result = await db.get.one(user, school);
            
            if (result.haveAccess) {
                const end_at = toDate(result.school.license_end, 'milliseconds');
                const date_now = Date.now();
                const end_left = +(((end_at - date_now) / (1000 * 60 * 60 * 24)).toFixed());
                result.school.license = { end_at, date_now, end_left };
            }

            return result;
        } catch (error) {
            return error;
        }
    },
    user_schools: async (code) => {
        try {
            let schools = await db.get.user_schools(code);
            schools.forEach(school => {
                const end_at = toDate(school.license_end, 'milliseconds');
                const date_now = Date.now();
                const end_left = +(((end_at - date_now) / (1000 * 60 * 60 * 24)).toFixed());
                school.license = { end_at, date_now, end_left };
            });
            return schools;
        } catch (error) {
            console.log(error);
            return error;
        }
    },
    school_users: async (code) => {
        console.log(code);
        try {
            return await db.get.school_users(code);
        } catch (error) {
            return error;
        }
    }
};