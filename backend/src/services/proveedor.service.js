const proveedorRepository = require('../repositories/proveedor.repository');
const ApiError = require('../utils/ApiError');

const validarProveedor = ({ nombre_empresa }) => {
  if (!nombre_empresa) {
    throw new ApiError(400, 'nombre_empresa es obligatorio.');
  }
};

const getAll = () => proveedorRepository.findAll();

const create = async (data) => {
  validarProveedor(data);
  return proveedorRepository.create(data);
};

const update = async (id, data) => {
  validarProveedor(data);
  const existente = await proveedorRepository.findById(id);
  if (!existente) {
    throw new ApiError(404, 'Proveedor no encontrado.');
  }
  return proveedorRepository.update(id, data);
};

const remove = async (id) => {
  const eliminado = await proveedorRepository.remove(id);
  if (!eliminado) {
    throw new ApiError(404, 'Proveedor no encontrado.');
  }
};

module.exports = { getAll, create, update, remove };
