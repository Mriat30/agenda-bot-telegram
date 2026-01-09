require "#{File.dirname(__FILE__)}/../../lib/routing"
require_relative '../../app/vistas/vista_menu'
require_relative '../../app/vistas/vista_registracion'

class DefaultRouter
  def initialize(logger, usuarios_router, main_router, obtener_usuario_por_id)
    @logger = logger
    @usuarios_router = usuarios_router
    @main_router = main_router
    @obtener_usuario_por_id = obtener_usuario_por_id
  end

  def handle(bot, message)
    id = message.chat.id

    if @usuarios_router.tiene_registracion_pendiente?(id)
      @usuarios_router.procesar_paso_registracion(bot, message)
    else
      manejar_usuario_sin_registro_pendiente(bot, message, id)
    end
    true
  end

  private

  def manejar_usuario_sin_registro_pendiente(bot, message, id)
    usuario = @obtener_usuario_por_id.ejecutar(id.to_s)

    if usuario
      VistaMenu.new(bot, message).mostrar_menu_usuario_registrado(usuario)
    else
      VistaRegistracion.new(bot, message).bienvenida
    end
  rescue StandardError => e
    @logger.error("Error obteniendo usuario: #{e.message}")
    VistaRegistracion.new(bot, message).bienvenida
  end
end
