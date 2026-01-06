class RepositorioUsuarios
  def initialize(api_url, logger)
    @api_url = api_url
    @logger = logger
  end

  def guardar(usuario)
    @logger.info "Registrando usuario:
     nombre=#{usuario.nombre},
     apellido=#{usuario.apellido}, telefono=#{usuario.nombre}, domicilio=#{usuario.domicilio}"
    respuesta = post_request(usuario)
    respuesta.status == 201
  end

  private

  def post_request(usuario)
    body = {
      'telegramId' => usuario.id,
      'name' => usuario.nombre,
      'lastName' => usuario.apellido,
      'phone' => usuario.telefono,
      'address' => usuario.domicilio
    }
    Faraday.post("#{@api_url}/users") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = body.to_json
    end
  end
end
