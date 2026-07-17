const asyncHandler = require('../utils/asyncHandler');
const categoriaService = require('../services/categoria.service');

const getAll = asyncHandler(async (req, res) => {
  const categorias = await categoriaService.getAll();
  res.json(categorias);
});

const create = asyncHandler(async (req, res) => {
  const categoria = await categoriaService.create(req.body.nombre_categoria);
  res.status(201).json(categoria);
});

module.exports = { getAll, create };
