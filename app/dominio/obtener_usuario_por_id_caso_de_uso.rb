require_relative '../../modelo/usuario'
require_relative '../repositorios/repositorio_usuarios'
class ObtenerUsuarioPorIdCasoDeUso
  def initialize(repositorio_usuarios)
    @repositorio_usuarios = repositorio_usuarios
  end

  def ejecutar(id)
    @repositorio_usuarios.encontrar_por_id(id)
  end
end
