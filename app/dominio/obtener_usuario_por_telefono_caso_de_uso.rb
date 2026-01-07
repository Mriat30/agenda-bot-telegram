require_relative '../repositorios/repositorio_usuarios'
require_relative '../../modelo/usuario'

class ObtenerUsuarioPorTelefonoCasoDeUso
  def initialize(repositorio_usuarios)
    @repositorio_usuarios = repositorio_usuarios
  end

  def ejecutar(un_telefono)
    @repositorio_usuarios.encontrar_por_telefono(un_telefono)
  end
end
