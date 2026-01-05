require "#{File.dirname(__FILE__)}/routers/main_router"
require_relative '../app/repositorios/repositorio_usuarios'
require_relative '../app/dominio/registrar_usuario_caso_de_uso'

class Dependencias
  attr_reader :registrar_usuario_caso_de_uso

  def initialize(api_url, logger)
    repositorio = RepositorioUsuarios.new(api_url, logger)
    @registrar_usuario_caso_de_uso = RegistrarUsuarioCasoDeUso.new(repositorio)
  end
end
