const productoRepository = require('../repositories/producto.repository');
const ApiError = require('../utils/ApiError');

const validarProducto = ({ nombre, precio_compra, precio_venta }) => {
  if (!nombre || precio_compra === undefined || precio_venta === undefined) {
    throw new ApiError(400, 'nombre, precio_compra y precio_venta son obligatorios.');
  }
  if (Number.isNaN(Number(precio_compra)) || Number.isNaN(Number(precio_venta))) {
    throw new ApiError(400, 'precio_compra y precio_venta deben ser numéricos.');
  }
};

const getAll = (search) => productoRepository.findAllActivos(search);

const create = async (data) => {
  validarProducto(data);
  return productoRepository.create(data);
};

const update = async (id, data) => {
  validarProducto(data);
  const existente = await productoRepository.findById(id);
  if (!existente) {
    throw new ApiError(404, 'Producto no encontrado.');
  }
  return productoRepository.update(id, data);
};

const softDelete = async (id) => {
  const eliminado = await productoRepository.softDelete(id);
  if (!eliminado) {
    throw new ApiError(404, 'Producto no encontrado.');
  }
};

module.exports = { getAll, create, update, softDelete };
