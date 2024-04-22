const { removeEmptyFromObject } = require("./functions.js")

exports.search = async ({ select = "*", table, where = {}, exact = [], toText = [], toDate = [], orderby = "created_at DESC", offset, limit = "20", more }, db) => {

    where = removeEmptyFromObject(where);

    let syntax = `SELECT ${select} FROM ${table} WHERE `;
    let values = [];
    const whereToArray = Object.keys(where);
    for (const key of whereToArray) {

        let nameKey = key;
        let opiration = exact.includes(key) ? "=" : "ILIKE";
    
        if (toText.includes(key)) {
            nameKey += "::text";
        } else if (toDate.includes(key)) {
            nameKey = `date(${nameKey})`;
            opiration = "=";
        };
        values.push(opiration == "=" ? where[key] : `%${where[key]}%`);
        syntax += `${nameKey} ${opiration} $${values.length} ${whereToArray.length > 1 ? 'AND' : ''} `;
    };

    syntax = syntax.slice(0, whereToArray.length > 1 ? -5 : -2);
    if (orderby) {
        syntax += ` ORDER BY ${orderby}`;
    }
    if (Number(offset)) {
        values.push(offset);
        syntax += ` OFFSET $${values.length}`;
    }
    if (Number(limit)) {
        values.push(limit);
        syntax += ` LIMIT $${values.length}`;
    }
    syntax += ` ${more || ''};`;

    // console.log({ syntax, values });
    try {
        return db ? await db.query(syntax, values) : { syntax, values };
    } catch (error) {
        console.log(error);
    }
};