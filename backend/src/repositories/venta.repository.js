const db = require('../config/db');

const getConnection = () => db.getConnection();

const insertarVenta = async (connection, { codigo_ticket, total, metodo_pago, usuario_id }) => {
  const [result] = await connection.query(
    'INSERT INTO ventas (codigo_ticket, total, metodo_pago, usuario_id) VALUES (?, ?, ?, ?)',
    [codigo_ticket, total, metodo_pago, usuario_id || null],
  );
  return result.insertId;
};

const insertarDetalle = async (connection, { venta_id, producto_id, cantidad, precio_unitario_momento }) => {
  await connection.query(
    'INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario_momento) VALUES (?, ?, ?, ?)',
    [venta_id, producto_id, cantidad, precio_unitario_momento],
  );
};

const findVentaById = async (id) => {
  const [rows] = await db.query(
    'SELECT id, codigo_ticket, fecha, total, metodo_pago, usuario_id FROM ventas WHERE id = ?',
    [id],
  );
  return rows[0] || null;
};

// nombre_producto no se guarda en detalle_ventas: se resuelve por JOIN contra
// productos. Como "eliminar" un producto es borrado lógico (activo = 0, ver
// Etapa 4), el nombre sigue disponible aunque el producto ya no esté activo.
const findAll = async () => {
  const [ventas] = await db.query(
    'SELECT id, codigo_ticket, fecha, total, metodo_pago, usuario_id FROM ventas ORDER BY fecha DESC',
  );
  if (ventas.length === 0) return [];

  const [detalles] = await db.query(
    `SELECT dv.id, dv.venta_id, dv.producto_id, dv.cantidad, dv.precio_unitario_momento,
            p.nombre AS nombre_producto
     FROM detalle_ventas dv
     LEFT JOIN productos p ON p.id = dv.producto_id`,
  );

  const detallePorVenta = new Map();
  for (const detalle of detalles) {
    const lista = detallePorVenta.get(detalle.venta_id) || [];
    lista.push(detalle);
    detallePorVenta.set(detalle.venta_id, lista);
  }

  return ventas.map((venta) => ({
    ...venta,
    monto_recibido: null,
    detalle: detallePorVenta.get(venta.id) || [],
  }));
};

module.exports = { getConnection, insertarVenta, insertarDetalle, findVentaById, findAll };
