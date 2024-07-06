const db = require("../../database");
const { search } = require("../utilities/db");
const { handleDbError } = require("../utilities/validator");

exports.create = async ({ school, course }) => {
    try {
        const result = await db.query(`
            WITH included AS (
                SELECT s.uid, s.name, COUNT(s.uid) AS included
                FROM students s
                JOIN lessons l ON s.uid = ANY(l.presents) OR s.uid = ANY(l.absents)
                WHERE l.course = $2
                GROUP BY s.uid
            ),
            boughted AS (
                SELECT s.uid, s.name, s.birthday, SUM(p.quantity) AS boughted
                FROM students s
                LEFT JOIN payments p ON p.student = s.uid
                WHERE p.course = $2
                GROUP BY s.uid, s.name, s.birthday
            )
            
            INSERT INTO lessons (school, course, presents, absents)
            VALUES (
                $1,
                $2,
                ARRAY(
                    SELECT b.uid
                    FROM boughted b
                    LEFT JOIN included i ON i.uid = b.uid
                    WHERE b.boughted > COALESCE(i.included, 0)
                ),
                $3
            )
            RETURNING 
                *,
                (
                    SELECT json_agg(json_build_object('uid', b.uid, 'name', b.name, 'birthday', b.birthday, 'rest', b.boughted - COALESCE(i.included, 0) - 1))
                    FROM boughted b
                    LEFT JOIN included i ON i.uid = b.uid
                    WHERE b.boughted > COALESCE(i.included, 0)
                ) AS students;    
        `, [ school, course, [] ]);
        return result.rows[0];
    } catch (error) {
        return handleDbError(error);
    };
};

exports.search = async (lesson, {offset, limit}) => {
    try {
        const result = await search({table: "lessons", where: lesson, exact: ["course"], toDate: ["created_at"], offset: offset, limit: limit}, db);
        console.log(result);
        return result.rows;
    } catch (error) {
        console.log(error);
        return handleDbError(error);
    };
};

exports.get = {
    one: async (lesson) => {
        try {
            const result = await db.query("SELECT * FROM lessons WHERE uid = $1;", [ lesson ]);
            return result.rows[0];
        } catch (error) {
            return handleDbError(error);
        };
    },
    student: async (uid) => {
        try {
            const result = await db.query("SELECT * FROM lessons WHERE $1 = ANY(presents) OR $1 = ANY(absents) ORDER BY created_at DESC;", [ uid ]);
            return result.rows;
        } catch (error) {
            return handleDbError(error);
        };
    },
    students: async ({course, students, date}) => {
        try {
            const result = await db.query(`
                WITH included AS (
                    SELECT s.uid, s.name, COUNT(s.uid) AS included
                    FROM students s
                    JOIN lessons l ON s.uid = ANY(l.presents) OR s.uid = ANY(l.absents)
                    WHERE l.course = $1 AND l.created_at <= $3
                    GROUP BY s.uid
                ),
                boughted AS (
                    SELECT s.uid, s.name, s.birthday, SUM(p.quantity) AS boughted
                    FROM students s
                    JOIN payments p ON p.student = s.uid
                    WHERE 
                        p.course = $1
                    AND 
                        s.uid = ANY($2::UUID[])
                    AND 
                        p.created_at <= $3
                    GROUP BY s.uid
                )
                
                SELECT b.*, COALESCE(i.included, 0) AS included, b.boughted - COALESCE(i.included, 0) - 1 AS rest
                FROM boughted b
                LEFT JOIN included i ON i.uid = b.uid
            `, [ course, students, date ]);
            return result.rows;
        } catch (error) {
            console.log(error);
            return handleDbError(error);
        };
    }
};

exports.changeStudentStatus = async (lesson, student, toPresent) => {
    try {
        const result = await db.query(`
            UPDATE lessons
            SET
                ${
                    toPresent ? 
                    `
                        presents = CASE WHEN $1 = ANY(presents) THEN presents ELSE array_append(presents, $1) END,
                        absents = array_remove(absents, $1)
                    ` : 
                    `
                        presents = array_remove(presents, $1),
                        absents = CASE WHEN $1 = ANY(absents) THEN absents ELSE array_append(absents, $1) END
                    `
                }
            WHERE uid = $2
            RETURNING *;
        `, [student, lesson]);
        
        // console.log(student);
        // console.log(`from ${toPresent ? "present" : "absent"} to ${toPresent ? "absent" : "present"}`);
        // console.log("Presents : " + result.rows[0].presents.length);
        // console.log("Absents : " + result.rows[0].absents.length);
        return result.rows[0];
    } catch (error) {
        return handleDbError(error);
    };
};