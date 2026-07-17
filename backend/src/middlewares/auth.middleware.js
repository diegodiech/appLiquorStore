const jwt = require('jsonwebtoken');
const ApiError = require('../utils/ApiError');

// Valida el JWT del header Authorization y adjunta { id, rol } a req.usuario.
const authMiddleware = (req, res, next) => {
  const header = req.headers.authorization;
  if (!header || !header.startsWith('Bearer ')) {
    return next(new ApiError(401, 'Token de autenticación requerido.'));
  }

  const token = header.slice('Bearer '.length);
  try {
    req.usuario = jwt.verify(token, process.env.JWT_SECRET);
    next();
  } catch (error) {
    next(new ApiError(401, 'Token inválido o expirado.'));
  }
};

module.exports = authMiddleware;
