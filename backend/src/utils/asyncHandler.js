// Envuelve controllers async para reenviar cualquier error al middleware
// de errores en vez de repetir try/catch en cada uno.
const asyncHandler = (fn) => (req, res, next) => {
  Promise.resolve(fn(req, res, next)).catch(next);
};

module.exports = asyncHandler;
