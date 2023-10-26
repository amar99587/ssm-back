const { Pool } = require("pg");

const connectionString = process.env.db_host;

const client = new Pool({
        connectionString,
        ssl: {
            rejectUnauthorized: false
        }
    });

module.exports = client;
