const db = require('../config/db');

const findAll = async () => {
  const [rows] = await db.query('SELECT id, nombre_categoria FROM categorias');
  return rows;
};

const create = async (nombreCategoria) => {
  const [result] = await db.query(
    'INSERT INTO categorias (nombre_categoria) VALUES (?)',
    [nombreCategoria],
  );
  return { id: result.insertId, nombre_categoria: nombreCategoria };
};

module.exports = { findAll, create };
