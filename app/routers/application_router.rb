require_relative '../routers/main_router'
require_relative '../routers/usuarios_router'

class ApplicationRouter
  def initialize(logger, dependencias)
    @logger = logger
    @routers = [
      UsuariosRouter.new(logger, dependencias.registrar_usuario_caso_de_uso),
      MainRouter.new(logger)
    ]
  end

  def handle(bot, message)
    @routers.each do |router|
      handled = router.handle(bot, message)
      break if handled
    end
  end
end
