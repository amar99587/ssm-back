const express = require("express");
const dotenv = require("dotenv");

dotenv.config();

const app = express();

const db = require("./database");
app.use("/v1", require("./v1/serve"));

// Handle 404
app.use((req, res) => { 
  res.status(404).json({ message: 'Not Found' });
});

app.listen(port = process.env.app_port, async () => {
    console.log(`1 - server listening on port ${port}`);
    try {
        await db.connect();
        console.log("2 - connection to the database was successful");
    } catch (error) {
        console.log(error);
    }
});