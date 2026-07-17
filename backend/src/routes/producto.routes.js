const express = require('express');
const router = express.Router();
const productoController = require('../controllers/producto.controller');
const authMiddleware = require('../middlewares/auth.middleware');
const requireRole = require('../middlewares/role.middleware');

router.get('/', authMiddleware, productoController.getAll);
router.post('/', authMiddleware, requireRole('administrador'), productoController.create);
router.put('/:id', authMiddleware, requireRole('administrador'), productoController.update);
router.delete('/:id', authMiddleware, requireRole('administrador'), productoController.remove);

module.exports = router;
