const asyncHandler = require('../utils/asyncHandler');
const productoService = require('../services/producto.service');

const getAll = asyncHandler(async (req, res) => {
  const productos = await productoService.getAll(req.query.search);
  res.json(productos);
});

const create = asyncHandler(async (req, res) => {
  const producto = await productoService.create(req.body);
  res.status(201).json(producto);
});

const update = asyncHandler(async (req, res) => {
  const producto = await productoService.update(req.params.id, req.body);
  res.json(producto);
});

const remove = asyncHandler(async (req, res) => {
  await productoService.softDelete(req.params.id);
  res.status(200).json({ mensaje: 'Producto eliminado.' });
});

module.exports = { getAll, create, update, remove };
