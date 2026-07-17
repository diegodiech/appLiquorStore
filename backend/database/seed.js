// Siembra los usuarios demo que AuthRepositoryMock ya usa en el frontend,
// para poder probar el login real de punta a punta. Idempotente: si el
// email ya existe, lo omite.
require('dotenv').config();
const bcrypt = require('bcryptjs');
const db = require('../src/config/db');

const usuarios = [
  { nombre: 'Ana Rodríguez', email: 'admin@licoreria.com', password: 'admin123', rol: 'administrador' },
  { nombre: 'Luis Pérez', email: 'cajero@licoreria.com', password: 'cajero123', rol: 'cajero' },
];

(async () => {
  try {
    for (const u of usuarios) {
      const [existentes] = await db.query('SELECT id FROM usuarios WHERE email = ?', [u.email]);
      if (existentes.length > 0) {
        console.log(`Ya existe: ${u.email}`);
        continue;
      }
      const password_hash = await bcrypt.hash(u.password, 10);
      await db.query(
        'INSERT INTO usuarios (nombre, email, password_hash, rol) VALUES (?, ?, ?, ?)',
        [u.nombre, u.email, password_hash, u.rol],
      );
      console.log(`Creado: ${u.email}`);
    }
  } catch (error) {
    console.error('Error al sembrar usuarios:', error.message);
    process.exitCode = 1;
  } finally {
    await db.end();
  }
})();
