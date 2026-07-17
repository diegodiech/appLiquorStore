const ApiError = require('../utils/ApiError');

const notFoundHandler = (req, res, next) => {
  next(new ApiError(404, `Ruta no encontrada: ${req.method} ${req.originalUrl}`));
};

// eslint-disable-next-line no-unused-vars
const errorHandler = (err, req, res, next) => {
  const statusCode = err instanceof ApiError ? err.statusCode : 500;
  if (statusCode === 500) {
    console.error(err);
  }
  res.status(statusCode).json({ mensaje: err.message || 'Error interno del servidor' });
};

module.exports = { notFoundHandler, errorHandler };
