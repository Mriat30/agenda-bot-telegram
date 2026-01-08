require_relative 'main_router'
require_relative 'usuarios_router'

class DefaultRouter
  def initialize(_logger, usuarios_router, main_router, obtener_usuario_por_id_caso_de_uso)
    @usuarios_router = usuarios_router
    @main_router = main_router
    @obtener_usuario_por_id_caso_de_uso = obtener_usuario_por_id_caso_de_uso
  end

  def handle(_bot, _message); end
end
