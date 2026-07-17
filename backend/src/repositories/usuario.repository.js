const db = require('../config/db');

const findAll = async () => {
  const [rows] = await db.query('SELECT id, nombre, email, rol FROM usuarios');
  return rows;
};

const findByEmail = async (email) => {
  const [rows] = await db.query('SELECT * FROM usuarios WHERE email = ?', [email]);
  return rows[0] || null;
};

const findById = async (id) => {
  const [rows] = await db.query('SELECT id, nombre, email, rol FROM usuarios WHERE id = ?', [id]);
  return rows[0] || null;
};

const create = async ({ nombre, email, password_hash, rol }) => {
  const [result] = await db.query(
    'INSERT INTO usuarios (nombre, email, password_hash, rol) VALUES (?, ?, ?, ?)',
    [nombre, email, password_hash, rol],
  );
  return findById(result.insertId);
};

module.exports = { findAll, findByEmail, findById, create };
