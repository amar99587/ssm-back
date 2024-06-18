const db = require("../../database");
const { handleDbError } = require("../utilities/validator");

exports.create = async (timetable) => {
  try {
    const data = [ timetable.school, timetable.course, timetable.start_at, timetable.end_at, timetable.day, timetable.date ];
    // if (timetable.fixed) { data.push(timetable.week) }
    // const result = await db.query(`INSERT INTO timetables (school_code, course_uid, start_at, end_at, ${timetable.fixed ? 'day, week' : 'date'}) VALUES ( $1, $2, $3, $4, ${timetable.fixed ? '$5, $6' : '$5'} ) RETURNING *;`, data);
    const result = await db.query(`INSERT INTO timetables (school_code, course_uid, start_at, end_at, day, date) VALUES ( $1, $2, $3, $4, $5, $6 ) RETURNING *;`, data);
    return result.rows[0];
  } catch (error) {
    return handleDbError(error);
  };
};

exports.delete = async (uid) => {
  try {
    const result = await db.query("DELETE from timetables WHERE uid = $1;", [ uid ]);
    return result.rows;
  } catch (error) {
    return handleDbError(error);
  };
};

exports.get = async (school) => {
    try {
      const result = await db.query(`
      SELECT t.uid as timetable_uid, t.day, t.week, t.date, t.start_at, t.end_at, c.uid, c.name, c.teacher, c.price
      FROM timetables t
      INNER JOIN courses c ON t.course_uid = c.uid WHERE school_code = $1;`, [ school ]);
      return result.rows;
    } catch (error) {
      return handleDbError(error);
    };
  };