const {Pool} = require("pg");
require("dotenv").config();

const pool = new Pool({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    database: process.env.DB_NAME,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD
});

pool.connect()
    .then(client => {
        console.log("Uspješno povezivanje s PostgreSQL bazom");
        client.release();
    })
    .catch(error => {
        console.error("Greška pri povezivanju s bazom:", error.message);
    });

module.exports = pool;