const express = require('express');
const cors = require('cors');
const db = require('./config/db'); // Asegúrate de que apunte a donde guardes tu db.js
const productoRoutes = require('./routes/producto.routes');
const categoriaRoutes = require('./routes/categoria.routes');
const ventaRoutes = require('./routes/venta.routes');
const proveedorRoutes = require('./routes/proveedor.routes');
const authRoutes = require('./routes/auth.routes');
const { notFoundHandler, errorHandler } = require('./middlewares/error.middleware');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares
app.use(cors()); 
app.use(express.json()); 

// RUTA DE PRUEBA ACTUALIZADA PARA MYSQL
app.get('/api/prueba-conexion', async (req, res) => {
    try {
        // En MySQL usamos comillas simples para la cadena de texto
        const [rows] = await db.query("SELECT 'Conexión Exitosa' AS estado");
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

// ENLAZAR RUTAS REALES
app.use('/api/productos', productoRoutes);
app.use('/api/categorias', categoriaRoutes);
app.use('/api/ventas', ventaRoutes);
app.use('/api/proveedores', proveedorRoutes);
app.use('/api/auth', authRoutes);

// 404 y manejador de errores centralizado (deben ir al final)
app.use(notFoundHandler);
app.use(errorHandler);

// Iniciar servidor
app.listen(PORT, () => {
    console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`);
});