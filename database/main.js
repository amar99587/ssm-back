const { Pool } = require("pg");

const client = new Pool({
    connectionString: process.env.db_host,
    ssl: {
        rejectUnauthorized: false
    }
});

module.exports = client;
