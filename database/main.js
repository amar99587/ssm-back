const { Client } = require("pg");

const client = new Client({
    port: process.env.db_port,
    host: process.env.db_host,
    user: process.env.db_user,
    database: process.env.db_name,
    password: process.env.db_password,
});

module.exports = client;