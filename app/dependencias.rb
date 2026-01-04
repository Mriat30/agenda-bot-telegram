require "#{File.dirname(__FILE__)}/routers/main_router"
require_relative '../app/repositorios/repositorio_usuarios'
require_relative '../app/dominio/registrar_usuario_caso_de_uso'

class Dependencias
  def self.construir(api_url, logger)
    repositorio = RepositorioUsuarios.new(api_url, logger)
    registracion_caso_de_uso = RegistrarUsuarioCasoDeUso.new(repositorio)

    MainRouter.construir(logger)
    UsuariosRouter.construir(logger, registracion_caso_de_uso)
  end
end
