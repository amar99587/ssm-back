const db = require("../database/link");

exports.new = async (req) => {
    try {
        let data = req.body;
        data.rules = data.rules || {};
        const getLink = await db.get(data);
        if (getLink.exists) {
            if (getLink.data.status == "inactive") {

                const rules = {};
                const sortedKeys = Object.keys(data.rules).sort();
                sortedKeys.forEach(key => {
                    rules[key] = data.rules[key];
                });

                const reqRule = JSON.stringify(rules);
                const dbRule = JSON.stringify(getLink.data.rules);

                if (reqRule == "{}" && dbRule == "{}") {
                    return { error: true, message: "link already exists, waiting for School" };
                } else if (reqRule != "{}" && dbRule != "{}") {
                    return { error: true, message: "link already exists, waiting for User" };
                } else {
                    data.status = "active";
                    if (reqRule == "{}") data.rules = false;
                    const updateLink = await db.update(data);
                    return updateLink;
                }
            } else {
                return { error: true, message: "link already exists" };
            }
        } else {
            data.type = "default";
            data.status = "inactive";
            data.rules = data.rules ? data.rules : "{}";
            const newLink = await db.new(data);
            return newLink;
        }
    } catch (error) {
        return error;
    }
};

exports.get = async (req) => {
    try {
        return await db.get(req.params);
    } catch (error) {
        return error;
    }
};

exports.update = async (req) => {
    try {
        return await db.update({ ...req.params, rules: req.body });
    } catch (error) {
        return error;
    }
};

exports.delete = async (req) => {
    try {
        return await db.delete(req.params);
    } catch (error) {
        return error;
    }
};