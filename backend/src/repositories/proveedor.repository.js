const db = require('../config/db');

const findAll = async () => {
  const [rows] = await db.query('SELECT id, nombre_empresa, telefono FROM proveedores');
  return rows;
};

const findById = async (id) => {
  const [rows] = await db.query(
    'SELECT id, nombre_empresa, telefono FROM proveedores WHERE id = ?',
    [id],
  );
  return rows[0] || null;
};

const create = async ({ nombre_empresa, telefono }) => {
  const [result] = await db.query(
    'INSERT INTO proveedores (nombre_empresa, telefono) VALUES (?, ?)',
    [nombre_empresa, telefono || null],
  );
  return findById(result.insertId);
};

const update = async (id, { nombre_empresa, telefono }) => {
  await db.query(
    'UPDATE proveedores SET nombre_empresa = ?, telefono = ? WHERE id = ?',
    [nombre_empresa, telefono || null, id],
  );
  return findById(id);
};

const remove = async (id) => {
  const [result] = await db.query('DELETE FROM proveedores WHERE id = ?', [id]);
  return result.affectedRows > 0;
};

module.exports = { findAll, findById, create, update, remove };
