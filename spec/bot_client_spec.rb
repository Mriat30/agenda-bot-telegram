require 'spec_helper'
require 'web_mock'
require "#{File.dirname(__FILE__)}/../app/bot_client"
require_relative '../spec/stubs/bot_client_stubs'

describe 'BotClient' do
  it 'should get a /version message and respond with current version' do
    token = 'fake_token'

    cuando_envio_texto(token, '/version')
    entonces_obtengo_texto(token, Version.current)

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /say_hi message and respond with Hola Emilio' do
    token = 'fake_token'

    cuando_envio_texto(token, '/say_hi Emilio')
    entonces_obtengo_texto(token, 'Hola, Emilio')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /start message and respond with Hola' do
    token = 'fake_token'

    cuando_envio_texto(token, '/start')
    entonces_obtengo_texto(token, 'Hola, Emilio')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /stop message and respond with Chau' do
    token = 'fake_token'

    cuando_envio_texto(token, '/stop')
    entonces_obtengo_texto(token, 'Chau, egutter')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get an unknown message message and respond with Do not understand' do
    token = 'fake_token'

    cuando_envio_texto(token, '/unknown')
    entonces_obtengo_texto(token, 'Uh? No te entiendo! Me repetis la pregunta?')

    app = BotClient.new(token)

    app.run_once
  end
end
