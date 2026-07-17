const asyncHandler = require('../utils/asyncHandler');
const authService = require('../services/auth.service');

const login = asyncHandler(async (req, res) => {
  const { email, password } = req.body;
  const resultado = await authService.login(email, password);
  res.json(resultado);
});

const listUsuarios = asyncHandler(async (req, res) => {
  const usuarios = await authService.listUsuarios();
  res.json(usuarios);
});

module.exports = { login, listUsuarios };
