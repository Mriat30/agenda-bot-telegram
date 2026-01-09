require 'spec_helper'
require_relative '../stubs/usuarios_stubs'
require_relative '../stubs/bot_client_stubs'

def entonces_el_registro_es_exitoso
  expect(WebMock).to have_requested(:post, "#{api_url}/users")
    .with(
      body: {
        telegramId: '141733544',
        name: 'test',
        lastName: 'sito',
        phone: '123456',
        address: 'Esquel 770'
      }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    ).once
end

describe 'RegistracionUsuario' do
  let(:token) { 'fake_token' }
  let(:api_url) { 'http://fake_url.com' }
  let(:app) { BotClient.new(token) }

  before(:each) do
    ENV['API_URL'] = api_url
  end

  it 'RU1: Dado que no estoy registrado, cuando envio "Hola", recibo formulario de registracion' do
    usuario = Usuario.new('141733544', 'test', 'sito', '123456', 'Esquel 770')
    cuando_el_usuario_no_existe(api_url, usuario)

    stubs_flujo_registracion(token)
    cuando_me_registro_exitosamente(api_url, usuario)

    cuando_realizo_el_flujo_de_registracion(token, usuario)
    entonces_el_registro_es_exitoso
  end

  it 'RU2: Dado que el telefono "123456" esta registrado, al intentar registrarme veo error' do
    usuario = Usuario.new('141733544', 'Juan', 'Perez', '123456', 'Esquel 770')
    stubs_preguntas_registracion(token)
    cuando_el_usuario_no_existe(api_url, usuario)

    entonces_obtengo_texto(token, '⚠️ El teléfono ya se encuentra registrado')
    cuando_me_registro_fallidamente_por_telefono_en_uso(api_url, usuario)
    cuando_realizo_el_flujo_de_registracion(token, usuario)

    expect(WebMock).to have_requested(:post, "https://api.telegram.org/bot#{token}/sendMessage")
      .with(body: hash_including('text' => '⚠️ El teléfono ya se encuentra registrado'))
  end

  xit 'RU3: Dado que el usuario ya esta registrado, al enviar un mensaje recibo el menu principal' do
    usuario_existente = Usuario.new('141733544', 'Juan', 'Perez', '123456', 'Esquel 770')
    cuando_el_usuario_ya_existe(api_url, usuario_existente)
    entonces_obtengo_bienvenida_usuario_registrado(token, 'Hola Juan! ¿Qué te gustaría hacer hoy?')

    cuando_envio_texto(token, 'Hola')
    app.run_once

    expect(WebMock).to have_requested(:post, "https://api.telegram.org/bot#{token}/sendMessage")
      .with(body: hash_including('text' => /Hola Juan/))
  end

  private

  def stubs_preguntas_registracion(token)
    entonces_obtengo_bienvenida_con_botones(token, 'Hola! Soy el asistente de Valeria Sapulia...')
    entonces_obtengo_texto(token, '¿Podrias decirme tu nombre?')
    entonces_obtengo_texto(token, 'Por favor, decime tu apellido')
    entonces_obtengo_texto(token, 'Por favor, decime tu telefono')
    entonces_obtengo_texto(token, 'Por favor, decime tu domicilio')
  end

  def stubs_flujo_registracion(token)
    stubs_preguntas_registracion(token)
    entonces_obtengo_texto(token, 'Perfecto, ya registre tus datos!')
  end

  def cuando_realizo_el_flujo_de_registracion(token, usuario)
    paso_inicial_y_bienvenida(token)
    paso_presionar_boton_registro(token)
    paso_nombre(token, usuario)
    paso_apellido(token, usuario)
    paso_telefono(token, usuario)
    paso_domicilio(token, usuario)
  end

  def paso_inicial_y_bienvenida(token)
    cuando_envio_texto(token, 'Hola')
    app.run_once
  end

  def paso_presionar_boton_registro(token)
    cuando_presiono_el_boton(token, 'Hola! Soy el asistente de Valeria Sapulia...', 'register')
    app.run_once
  end

  def paso_nombre(token, usuario)
    cuando_envio_texto(token, usuario.nombre)
    app.run_once
  end

  def paso_apellido(token, usuario)
    cuando_envio_texto(token, usuario.apellido)
    app.run_once
  end

  def paso_telefono(token, usuario)
    cuando_envio_texto(token, usuario.telefono)
    app.run_once
  end

  def paso_domicilio(token, usuario)
    cuando_envio_texto(token, usuario.domicilio)
    app.run_once
  end
end
