const asyncHandler = require('../utils/asyncHandler');
const ventaService = require('../services/venta.service');

const registrarVenta = asyncHandler(async (req, res) => {
  const venta = await ventaService.registrarVenta({
    ...req.body,
    usuario_id: req.usuario.id,
  });
  res.status(201).json(venta);
});

const getAll = asyncHandler(async (req, res) => {
  const ventas = await ventaService.getAll();
  res.json(ventas);
});

module.exports = { registrarVenta, getAll };
