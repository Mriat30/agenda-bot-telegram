require 'spec_helper'
require 'web_mock'
require_relative '../../../app/repositorios/repositorio_usuarios'
require_relative '../../../modelo/usuario'
require_relative '../../stubs/usuarios_stubs'

describe RepositorioUsuarios do
  let(:logger) { SemanticLogger['BotClient'] }
  let(:api_url) { 'http://fake_url.com' }
  let(:repositorio) do
    described_class.new(api_url, logger)
  end

  before(:each) do
    ENV['API_URL'] = api_url
    SemanticLogger.default_level = :fatal
  end

  it 'el repositorio guarda correctamente el usuario' do
    usuario = Usuario.new('1', 'test', 'sito',
                          '1234567899',
                          'Esquel 770')
    cuando_me_registro_exitosamente('fake_token', api_url, usuario)
    resultado = repositorio.guardar(usuario)

    expect(resultado).to eq(true)
  end
end
