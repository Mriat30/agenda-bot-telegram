require_relative './vista_base'

class VistaMenu < VistaBase
  def mostrar_menu_usuario_registrado(usuario)
    nombre = usuario.respond_to?(:nombre) ? usuario.nombre : usuario[:nombre] || usuario['nombre']
    mandar_mensaje("Hola #{nombre}! ¿Qué te gustaría hacer hoy?")
  end
end
