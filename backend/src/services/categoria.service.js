const categoriaRepository = require('../repositories/categoria.repository');
const ApiError = require('../utils/ApiError');
const { rethrowAsConflict } = require('../utils/mysqlErrors');

const getAll = () => categoriaRepository.findAll();

const create = async (nombreCategoria) => {
  if (!nombreCategoria) {
    throw new ApiError(400, 'nombre_categoria es obligatorio.');
  }
  try {
    return await categoriaRepository.create(nombreCategoria);
  } catch (error) {
    rethrowAsConflict(error, 'Ya existe una categoría con ese nombre.');
  }
};

module.exports = { getAll, create };
