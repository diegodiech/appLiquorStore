const express = require('express');
const cors = require('cors');
const db = require('./db'); // Importamos la conexión a la base de datos
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares
app.use(cors()); // Permite que tu compañera se conecte desde Flutter
app.use(express.json()); // Permite recibir formato JSON en las peticiones

// RUTA DE PRUEBA: Verifica que el servidor y la base de datos están conectados
app.get('/api/prueba-conexion', async (req, res) => {
    try {
        // Hacemos una consulta simple para ver si la base de datos responde
        const [rows] = await db.query('SELECT "Conexión Exitosa" AS estado');
        res.json({
            mensaje: "¡El servidor de Express está vivo!",
            base_datos: rows[0].estado
        });
    } catch (error) {
        console.error("Error al conectar a la base de datos:", error);
        res.status(500).json({ 
            mensaje: "Servidor activo, pero hubo un error con la base de datos", 
            error: error.message 
        });
    }
});

// Iniciar servidor
app.listen(PORT, () => {
    console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`);
});