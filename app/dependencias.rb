require "#{File.dirname(__FILE__)}/routers/main_router"

class Dependencias
  def self.construir(logger)
    MainRouter.construir(logger)
  end
end
