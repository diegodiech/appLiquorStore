const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const usuarioRepository = require('../repositories/usuario.repository');
const ApiError = require('../utils/ApiError');

const login = async (email, password) => {
  if (!email || !password) {
    throw new ApiError(400, 'Email y contraseña son obligatorios.');
  }

  const usuario = await usuarioRepository.findByEmail(email);
  if (!usuario) {
    throw new ApiError(401, 'Credenciales incorrectas.');
  }

  const esValida = await bcrypt.compare(password, usuario.password_hash);
  if (!esValida) {
    throw new ApiError(401, 'Credenciales incorrectas.');
  }

  const token = jwt.sign(
    { id: usuario.id, rol: usuario.rol },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN || '1d' },
  );

  return {
    token,
    usuario: {
      id: usuario.id,
      nombre: usuario.nombre,
      email: usuario.email,
      rol: usuario.rol,
    },
  };
};

const listUsuarios = () => usuarioRepository.findAll();

module.exports = { login, listUsuarios };
