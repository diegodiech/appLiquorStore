const mysql = require('mysql2');
require('dotenv').config();

// Crear un pool de conexiones (más eficiente que una conexión única)
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT || 3306,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Exportar la promesa para usar async/await en tus consultas SQL
module.exports = pool.promise();