class RepositorioUsuarios
  class ErrorDeApi < StandardError; end
  class ErrorDeConflicto < StandardError; end

  def initialize(api_url, logger)
    @api_url = api_url
    @logger = logger
  end

  def guardar(usuario)
    @logger.info "Registrando usuario:
     nombre=#{usuario.nombre},
     apellido=#{usuario.apellido}, telefono=#{usuario.nombre}, domicilio=#{usuario.domicilio}"
    respuesta = post_request(usuario)
    return true if respuesta.status == 201

    manejar_respuesta_al_guardar(respuesta)
  end

  def encontrar_por_telefono(un_telefono); end

  private

  def manejar_respuesta_al_guardar(respuesta)
    body = begin
      JSON.parse(respuesta.body)
    rescue StandardError
      {}
    end
    mensaje = body['message'] || 'Error desconocido'
    case respuesta.status
    when 409
      @logger.warn "Conflicto detectado: #{mensaje}"
      raise ErrorDeConflicto, mensaje

    else
      @logger.error "Error inesperado (Status #{respuesta.status}): #{mensaje}"
      raise ErrorDeAPI, 'El servicio no está disponible'
    end
  end

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
