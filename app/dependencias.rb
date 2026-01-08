require "#{File.dirname(__FILE__)}/routers/main_router"
require_relative '../app/repositorios/repositorio_usuarios'
require_relative '../app/dominio/registrar_usuario_caso_de_uso'
require_relative '../app/dominio/obtener_usuario_por_id_caso_de_uso'
require_relative '../app/dominio/obtener_usuario_por_telefono_caso_de_uso'
require_relative '../app/routers/application_router'
require_relative '../app/routers/usuarios_router'
require_relative '../app/routers/main_router'
require_relative '../app/routers/default_router'

class Dependencias
  attr_reader :application_router

  def initialize(api_url, logger)
    repositorio = RepositorioUsuarios.new(api_url, logger)
    @application_router = ApplicationRouter.new(logger, [
                                                  construir_usuarios_router(logger, repositorio),
                                                  construir_main_router(logger),
                                                  construir_default_router(logger, repositorio)
                                                ])
  end

  private

  def construir_usuarios_router(logger, repositorio_usuarios)
    registrar_usuario_caso_de_uso = RegistrarUsuarioCasoDeUso.new(repositorio_usuarios)
    UsuariosRouter.new(logger, registrar_usuario_caso_de_uso)
  end

  def construir_main_router(logger)
    MainRouter.new(logger)
  end

  def construir_default_router(logger, repositorio_usuarios)
    obtener_usuario_por_id = ObtenerUsuarioPorIdCasoDeUso.new(repositorio_usuarios)
    DefaultRouter.new(logger,
                      construir_usuarios_router(logger, repositorio_usuarios),
                      construir_main_router(logger),
                      obtener_usuario_por_id)
  end
end
