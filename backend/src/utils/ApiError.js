class ApiError extends Error {
  constructor(statusCode, mensaje) {
    super(mensaje);
    this.statusCode = statusCode;
  }
}

module.exports = ApiError;
