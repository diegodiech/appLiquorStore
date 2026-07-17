const ventaRepository = require('../repositories/venta.repository');
const productoRepository = require('../repositories/producto.repository');
const ApiError = require('../utils/ApiError');

const METODOS_PAGO_VALIDOS = ['Efectivo', 'QR'];

const registrarVenta = async ({ metodo_pago, usuario_id, monto_recibido, productos }) => {
  if (!Array.isArray(productos) || productos.length === 0) {
    throw new ApiError(400, 'No se puede registrar una venta sin productos.');
  }
  if (!METODOS_PAGO_VALIDOS.includes(metodo_pago)) {
    throw new ApiError(400, `metodo_pago debe ser uno de: ${METODOS_PAGO_VALIDOS.join(', ')}.`);
  }

  const connection = await ventaRepository.getConnection();
  try {
    await connection.beginTransaction();

    // Precio y nombre se toman del producto en BD en el momento de la venta,
    // nunca del valor que mande el cliente: evita que un cliente manipulado
    // registre una venta con un precio arbitrario.
    const detalle = [];
    let total = 0;

    for (const item of productos) {
      if (!item.producto_id || !Number.isInteger(item.cantidad) || item.cantidad <= 0) {
        throw new ApiError(400, 'Cada producto requiere producto_id y una cantidad entera positiva.');
      }

      const producto = await productoRepository.lockForSale(connection, item.producto_id);
      if (!producto) {
        throw new ApiError(404, `El producto ${item.producto_id} no existe.`);
      }
      if (producto.stock_actual < item.cantidad) {
        throw new ApiError(
          409,
          `Stock insuficiente para "${producto.nombre}" (disponible: ${producto.stock_actual}).`,
        );
      }

      total += producto.precio_venta * item.cantidad;
      detalle.push({
        producto_id: producto.id,
        nombre_producto: producto.nombre,
        cantidad: item.cantidad,
        precio_unitario_momento: producto.precio_venta,
      });
    }

    const codigo_ticket = `TCK-${Date.now()}`;
    const ventaId = await ventaRepository.insertarVenta(connection, {
      codigo_ticket,
      total,
      metodo_pago,
      usuario_id,
    });

    for (const item of detalle) {
      await productoRepository.decrementStock(connection, item.producto_id, item.cantidad);
      await ventaRepository.insertarDetalle(connection, { venta_id: ventaId, ...item });
    }

    await connection.commit();

    const venta = await ventaRepository.findVentaById(ventaId);
    return {
      ...venta,
      monto_recibido: monto_recibido ?? null,
      detalle: detalle.map((item) => ({ venta_id: ventaId, ...item })),
    };
  } catch (error) {
    await connection.rollback();
    throw error;
  } finally {
    connection.release();
  }
};

const getAll = () => ventaRepository.findAll();

module.exports = { registrarVenta, getAll };
