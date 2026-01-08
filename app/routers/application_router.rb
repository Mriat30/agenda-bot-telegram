require_relative '../routers/main_router'
require_relative '../routers/usuarios_router'

class ApplicationRouter
  def initialize(logger, routers)
    @logger = logger
    @routers = routers
  end

  def handle(bot, message)
    @routers.each do |router|
      handled = router.handle(bot, message)
      break if handled
    end
  end
end
