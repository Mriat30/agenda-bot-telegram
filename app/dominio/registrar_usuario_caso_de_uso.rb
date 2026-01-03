class RegistrarUsuarioCasoDeUso
  def initialize(repositorio_usuarios)
    @repositorio_usuarios = repositorio_usuarios
  end

  def ejecutar(id_usuario, nombre, apellido, telefono, domicilio)
    usuario = Usuario.new(id_usuario, nombre, apellido, telefono, domicilio)
    @repositorio_usuarios.guardar(usuario)
  end
end
