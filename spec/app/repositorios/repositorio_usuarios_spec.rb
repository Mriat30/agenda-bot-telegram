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
    cuando_me_registro_exitosamente(api_url, usuario)
    resultado = repositorio.guardar(usuario)

    expect(resultado).to eq(true)
  end

  it 'al querer guardar un usuario con el telefono ya registradp, lanza error' do
    usuario = Usuario.new('1', 'test', 'sito',
                          '1234567899',
                          'Esquel 770')
    cuando_me_registro_fallidamente_por_telefono_en_uso(api_url, usuario)

    expect do
      repositorio.guardar(usuario)
    end.to raise_error(RepositorioUsuarios::ErrorDeConflicto, 'El teléfono ya se encuentra registrado')
  end

  describe 'encontrar_por_telefono' do
    it 'devuelve un usuario segun su numero de telfono, si este esta registrado' do
      un_telefono = '1234567'
      usuario = Usuario.new('1', 'test', 'sito', un_telefono, 'Esquel 770')
      cuando_obtengo_un_usuario_mediante_su_telefono_exitosamente(api_url, usuario)

      resultado = repositorio.encontrar_por_telefono(un_telefono)

      expect(resultado.id).to eq(usuario.id)
      expect(resultado.telefono).to eq(usuario.telefono)
    end

    it 'si el usuario no existe devuelve nil' do
      un_telefono = '1234567'
      usuario = Usuario.new('1', 'test', 'sito', un_telefono, 'Esquel 770')
      cuando_no_encuentro_el_usuario_segun_su_numero_de_telefono(api_url, usuario)

      resultado = repositorio.encontrar_por_telefono(un_telefono)

      expect(resultado).to eq(nil)
    end
  end

  describe 'encontrar_por_id' do
    it 'devuelve un usuario segun su numero id, si este esta registrado' do
      un_id = '1234567'
      usuario = Usuario.new(un_id, 'test', 'sito', '1234561', 'Esquel 770')
      cuando_obtengo_un_usuario_mediante_su_id_exitosamente(api_url, usuario)

      resultado = repositorio.encontrar_por_id(un_id)

      expect(resultado.id).to eq(usuario.id)
      expect(resultado.telefono).to eq(usuario.telefono)
    end
  end
end
