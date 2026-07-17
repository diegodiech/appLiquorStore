const categoriaRepository = require('../repositories/categoria.repository');
const ApiError = require('../utils/ApiError');

const getAll = () => categoriaRepository.findAll();

const create = async (nombreCategoria) => {
  if (!nombreCategoria) {
    throw new ApiError(400, 'nombre_categoria es obligatorio.');
  }
  return categoriaRepository.create(nombreCategoria);
};

module.exports = { getAll, create };
