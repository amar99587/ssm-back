const { Pool } = require("pg");

const connectionString = process.env.db_host;

<<<<<<< HEAD
// const { Pool } = require("pg");

// const client = new Pool({
//         connectionString: process.env.db_host,
//         ssl: {
//             rejectUnauthorized: false
//         }
//     });

module.exports = client;
=======
const client = new Pool({
        connectionString,
        ssl: {
            rejectUnauthorized: false
        }
    });

module.exports = client;
>>>>>>> 3f24ab403406d6a981a45417352520ef37544e76
