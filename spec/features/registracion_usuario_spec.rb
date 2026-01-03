require 'spec_helper'

describe 'RegistracionUsuario' do
  let(:token) { 'fake_token' }
  let(:api_url) { 'http://fake_url.com' }
  let(:app) { BotClient.new(token) }

  before(:each) do
    ENV[API_URL] = api_url
  end

  xit 'RU1: Dado que no estoy registrado, cuando envio "Hola", recibo formulario de registracion' do
    usuario = Usuario.new('1234567', 'test',
                          'sito',
                          '123456',
                          'Esquel 770')
    this.cuando_realizo_el_flujo_de_registracion(token, usuario)
  end

  private

  def cuando_realizo_el_flujo_de_registracion(token, usuario)
    paso_inicial_y_bienvenida(token)
    paso_presionar_boton_registro(token)
    paso_datos_personales(token, usuario)
    paso_finalizacion_domicilio(token, usuario)
  end

  def paso_inicial_y_bienvenida(token)
    cuando_envio_texto(token, 'Hola')
    entonces_obtengo_texto(token, 'Hola! Soy el asistente de Valeria Sapulia...') # Simplificado por brevedad
    app.run_once
  end

  def paso_presionar_boton_registro(token)
    cuando_presiono_el_boton(token, 'Por favor, presiona el boton de registracion', 'register')
    entonces_obtengo_texto(token, '¿Podrias decirme tu nombre?')
    app.run_once
  end

  def paso_datos_personales(token, usuario)
    cuando_envio_texto(token, usuario.nombre)
    entonces_obtengo_texto(token, 'Por favor, decime tu apellido')
    app.run_once

    cuando_envio_texto(token, usuario.apellido)
    entonces_obtengo_texto(token, 'Por favor, decime tu telefono')
    app.run_once
  end

  def paso_finalizacion_domicilio(token, usuario)
    cuando_envio_texto(token, usuario.telefono)
    entonces_obtengo_texto(token, 'Por favor, decime tu domicilio')
    app.run_once

    cuando_envio_texto(token, usuario.domicilio)
    entonces_obtengo_texto(token, 'Perfecto, ya registre tus datos!')
    app.run_once
  end
end
