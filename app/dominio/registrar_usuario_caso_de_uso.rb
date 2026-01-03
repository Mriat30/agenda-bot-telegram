class RegistrarUsuarioCasoDeUso
  def initialize(repositorio_usuarios)
    @repositorio_usuarios = repositorio_usuarios
  end

  def ejecutar(id_usuario, nombre, email)
    usuario = Usuario.new(id_usuario, nombre, email)
    @repositorio_usuarios.guardar(usuario)
  end
end
