const ApiError = require('./ApiError');

// Traduce una violación de restricción UNIQUE de MySQL a un 409 legible en
// vez de dejar pasar el error crudo de la BD como un 500.
const rethrowAsConflict = (error, mensaje) => {
  if (error.code === 'ER_DUP_ENTRY') {
    throw new ApiError(409, mensaje);
  }
  throw error;
};

module.exports = { rethrowAsConflict };
