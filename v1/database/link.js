const db = require("../../database");
const { handleDbError } = require("../utilities/validator");

exports.new = async ({ user, school, rules, type, status }) => {
  try {
    user = user.toLowerCase();
    school = school.toLowerCase();
    const result = await db.query("INSERT INTO users_schools (user_code, school_code, rules, type, status) VALUES ( $1, $2, $3, $4, $5 ) RETURNING *;", [user, school, rules, type, status]);
    return result.rows[0];
  } catch (error) {
    return handleDbError(error);
  };
};

exports.get = async ({ user, school }) => {
  try {
    user = user.toLowerCase();
    school = school.toLowerCase();
    const result = await db.query("SELECT * FROM users_schools WHERE user_code = $1 AND school_code = $2;", [user, school]);
    return {
      exists: !!result.rowCount,
      data: result.rows[0],
    };
  } catch (error) {
    return handleDbError(error);
  };
};

exports.update = async ({ user, school, rules, type, status }) => {
  try {
    user = user.toLowerCase();
    school = school.toLowerCase();
    let query = "UPDATE users_schools SET ";
    let data = [user, school];

    if (rules) {
      data.push(rules);
      query += `rules = $${data.length}`;
    }
    if (type) {
      data.push(type);
      query += `${data.length == 3 ? "" : ","} type = $${data.length}`;
    }
    if (status) {
      data.push(status);
      query += `${data.length == 3 ? "" : ","} status = $${data.length}`;
    }

    query += " WHERE user_code = $1 AND school_code = $2 RETURNING *;"
    // console.log(query, data);
    const result = await db.query(query, data);
    return result.rows[0];
  } catch (error) {
    return handleDbError(error);
  };
};

exports.delete = async ({ user, school }) => {
  try {
    user = user.toLowerCase();
    school = school.toLowerCase();
    const result = await db.query("DELETE FROM users_schools WHERE user_code = $1 AND school_code = $2;", [user, school]);
    // console.log(result);
    return result.rows;
  } catch (error) {
    return handleDbError(error);
  };
};