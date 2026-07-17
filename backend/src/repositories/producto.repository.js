const db = require('../config/db');

const SELECT_BASE = `
  SELECT p.id, p.codigo_barra, p.nombre, p.precio_compra, p.precio_venta,
         p.stock_actual, p.stock_minimo, p.categoria_id, p.proveedor_id, p.activo
  FROM productos p
`;

const findAllActivos = async (search) => {
  if (search) {
    const like = `%${search}%`;
    const [rows] = await db.query(
      `${SELECT_BASE} WHERE p.activo = 1 AND (p.nombre LIKE ? OR p.codigo_barra LIKE ?)`,
      [like, like],
    );
    return rows;
  }
  const [rows] = await db.query(`${SELECT_BASE} WHERE p.activo = 1`);
  return rows;
};

const findById = async (id) => {
  const [rows] = await db.query(`${SELECT_BASE} WHERE p.id = ?`, [id]);
  return rows[0] || null;
};

const create = async (producto) => {
  const {
    codigo_barra, nombre, precio_compra, precio_venta,
    stock_actual, stock_minimo, categoria_id, proveedor_id,
  } = producto;

  const [result] = await db.query(
    `INSERT INTO productos
      (codigo_barra, nombre, precio_compra, precio_venta, stock_actual, stock_minimo, categoria_id, proveedor_id)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      codigo_barra || null,
      nombre,
      precio_compra,
      precio_venta,
      stock_actual || 0,
      stock_minimo || 5,
      categoria_id || null,
      proveedor_id || null,
    ],
  );
  return findById(result.insertId);
};

const update = async (id, producto) => {
  const {
    codigo_barra, nombre, precio_compra, precio_venta,
    stock_actual, stock_minimo, categoria_id, proveedor_id,
  } = producto;

  await db.query(
    `UPDATE productos SET
       codigo_barra = ?, nombre = ?, precio_compra = ?, precio_venta = ?,
       stock_actual = ?, stock_minimo = ?, categoria_id = ?, proveedor_id = ?
     WHERE id = ?`,
    [
      codigo_barra || null,
      nombre,
      precio_compra,
      precio_venta,
      stock_actual,
      stock_minimo,
      categoria_id || null,
      proveedor_id || null,
      id,
    ],
  );
  return findById(id);
};

const softDelete = async (id) => {
  const [result] = await db.query('UPDATE productos SET activo = 0 WHERE id = ?', [id]);
  return result.affectedRows > 0;
};

// Bloquea la fila dentro de una transacción (FOR UPDATE) para que dos ventas
// concurrentes no descuenten stock sobre el mismo valor ya obsoleto.
const lockForSale = async (connection, id) => {
  const [rows] = await connection.query(
    'SELECT id, nombre, precio_venta, stock_actual FROM productos WHERE id = ? FOR UPDATE',
    [id],
  );
  return rows[0] || null;
};

const decrementStock = async (connection, id, cantidad) => {
  await connection.query(
    'UPDATE productos SET stock_actual = stock_actual - ? WHERE id = ?',
    [cantidad, id],
  );
};

module.exports = {
  findAllActivos, findById, create, update, softDelete, lockForSale, decrementStock,
};
