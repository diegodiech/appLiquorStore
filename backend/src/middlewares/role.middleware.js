const ApiError = require('../utils/ApiError');

// Uso: router.post('/', authMiddleware, requireRole('administrador'), controller)
const requireRole = (...rolesPermitidos) => (req, res, next) => {
  if (!req.usuario || !rolesPermitidos.includes(req.usuario.rol)) {
    return next(new ApiError(403, 'No tienes permisos para realizar esta acción.'));
  }
  next();
};

module.exports = requireRole;
