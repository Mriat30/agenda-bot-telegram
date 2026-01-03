require 'web_mock'

def cuando_me_registro_exitosamente(_token, api_url, usuario)
  datos_usuario = {
    id: usuario.id,
    nombre: usuario.nombre,
    apellido: usuario.apellido,
    telefono: usuario.telefono,
    domicilio: usuario.domicilio
  }

  stub_request(:post, "#{api_url}/users")
    .with(
      body: datos_usuario.to_json,
      headers: {
        'Content-Type' => 'application/json',
        'Accept' => '*/*'
      }
    )
    .to_return(status: 201, body: '', headers: {})
end
