const express = require('express');
const router = express.Router();
const categoriaController = require('../controllers/categoria.controller');
const authMiddleware = require('../middlewares/auth.middleware');
const requireRole = require('../middlewares/role.middleware');

router.get('/', authMiddleware, categoriaController.getAll);
router.post('/', authMiddleware, requireRole('administrador'), categoriaController.create);

module.exports = router;
