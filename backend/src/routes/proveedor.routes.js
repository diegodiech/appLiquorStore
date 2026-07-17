const express = require('express');
const router = express.Router();
const proveedorController = require('../controllers/proveedor.controller');
const authMiddleware = require('../middlewares/auth.middleware');
const requireRole = require('../middlewares/role.middleware');

router.get('/', authMiddleware, proveedorController.getAll);
router.post('/', authMiddleware, requireRole('administrador'), proveedorController.create);
router.put('/:id', authMiddleware, requireRole('administrador'), proveedorController.update);
router.delete('/:id', authMiddleware, requireRole('administrador'), proveedorController.remove);

module.exports = router;
