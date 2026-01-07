require 'web_mock'

def cuando_me_registro_exitosamente(api_url, usuario)
  datos_usuario = {
    telegramId: usuario.id,
    name: usuario.nombre,
    lastName: usuario.apellido,
    phone: usuario.telefono,
    address: usuario.domicilio
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

def cuando_me_registro_fallidamente_por_telefono_en_uso(api_url, usuario)
  datos_usuario = {
    telegramId: usuario.id,
    name: usuario.nombre,
    lastName: usuario.apellido,
    phone: usuario.telefono,
    address: usuario.domicilio
  }

  error_body = {
    error: 'Conflict',
    message: 'El teléfono ya se encuentra registrado'
  }.to_json

  stub_request(:post, "#{api_url}/users")
    .with(
      body: datos_usuario.to_json,
      headers: {
        'Content-Type' => 'application/json',
        'Accept' => '*/*'
      }
    )
    .to_return(
      status: 409,
      body: error_body,
      headers: { 'Content-Type' => 'application/json' }
    )
end

def entonces_obtengo_bienvenida_con_botones(token, message_text)
  stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
    .with(
      body: {
        'chat_id' => '141733544',
        'text' => message_text,
        'reply_markup' => '{"inline_keyboard":[[{"text":"Registrarme","callback_data":"register"}]]}'
      }
    )
    .to_return(status: 200, body: { "ok": true }.to_json, headers: {})
end

def entonces_obtengo_texto_con_force_reply(token, text)
  stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
    .with(
      body: hash_including({
                             'chat_id' => '141733544',
                             'text' => text,
                             'reply_markup' => '{"force_reply":true}'
                           })
    )
    .to_return(status: 200, body: { ok: true }.to_json, headers: {})
end
