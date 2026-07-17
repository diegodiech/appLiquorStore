const express = require('express');
const router = express.Router();
const ventaController = require('../controllers/venta.controller');
const authMiddleware = require('../middlewares/auth.middleware');
const requireRole = require('../middlewares/role.middleware');

// Cualquier usuario autenticado puede registrar una venta (rol cajero en la UI).
router.post('/', authMiddleware, ventaController.registrarVenta);

// El historial de ventas es solo para el admin (SalesHistoryScreen).
router.get('/', authMiddleware, requireRole('administrador'), ventaController.getAll);

module.exports = router;
