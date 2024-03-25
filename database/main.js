const { Pool } = require("pg");

const db = new Pool({
    connectionString: process.env.db_host
});

module.exports = db;