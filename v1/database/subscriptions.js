const db = require("../../database");
const { handleDbError } = require("../utilities/validator");

exports.create = async ({ id, school, amount, subscription }) => {
    try {
        const updateSubscription =  await db.query(`
            INSERT INTO subscriptions (checkout, school, amount, duration)
            VALUES ($1, $2, $3, $4)
            ON CONFLICT (checkout) DO NOTHING;
            `, 
            [ id, school, amount, subscription.duration ]
        );
        return { subscription: +updateSubscription.rowCount ? 'added' : 'already exists', id, school, amount, subscription };
    } catch (error) {
        console.log(error);
        return handleDbError(error);
    };
};

exports.exist = async (checkout) => {
    try {
        const result =  await db.query("select count(*) from subscriptions where checkout = $1", [ checkout ]);
        return !!+result.rows[0].count;
    } catch (error) {
        console.log(error);
        return handleDbError(error);
    };
};

exports.get = async (checkout) => {
    try {
        const result =  await db.query("select * from subscriptions where checkout = $1", [ checkout ]);
        return result.rows[0];
    } catch (error) {
        console.log(error);
        return handleDbError(error);
    };
};

exports.update = {
    checkout: async (id, school) => {
        try {
            const result = await db.query(`
                UPDATE subscriptions
                SET school = $2 
                where checkout = $1;`, 
                [ id, school ]
            );
            return { subscription: +result.rowCount ? 'updated successfully' : "can't update", checkout: id };
        } catch (error) {
            console.log(error);
            return handleDbError(error);
        };
    },
    duration: async ({ id, school, subscription }) => {
        try {
            const result = await db.query(`
                UPDATE schools
                SET license_end = CASE 
                    WHEN license_end < CURRENT_DATE THEN CURRENT_DATE + INTERVAL '${subscription.duration} months'
                    ELSE license_end + INTERVAL '${subscription.duration} months'
                END
                where code = $1;`, 
                [ school ]
            );
            return { subscription: +result.rowCount ? 'updated successfully' : "can't update", id, school, ...subscription };
        } catch (error) {
            console.log(error);
            return handleDbError(error);
        };
    }
};