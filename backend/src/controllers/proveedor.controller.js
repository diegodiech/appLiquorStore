const asyncHandler = require('../utils/asyncHandler');
const proveedorService = require('../services/proveedor.service');

const getAll = asyncHandler(async (req, res) => {
  const proveedores = await proveedorService.getAll();
  res.json(proveedores);
});

const create = asyncHandler(async (req, res) => {
  const proveedor = await proveedorService.create(req.body);
  res.status(201).json(proveedor);
});

const update = asyncHandler(async (req, res) => {
  const proveedor = await proveedorService.update(req.params.id, req.body);
  res.json(proveedor);
});

const remove = asyncHandler(async (req, res) => {
  await proveedorService.remove(req.params.id);
  res.status(200).json({ mensaje: 'Proveedor eliminado.' });
});

module.exports = { getAll, create, update, remove };
