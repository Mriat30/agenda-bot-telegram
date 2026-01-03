require 'spec_helper'
require "#{File.dirname(__FILE__)}/../../../app/dominio/registrar_usuario_caso_de_uso"
require "#{File.dirname(__FILE__)}/../../../app/repositorios/repositorio_usuarios"
require "#{File.dirname(__FILE__)}/../../../modelo/usuario"

describe RegistrarUsuarioCasoDeUso do
  let(:repositorio) { instance_double(RepositorioUsuarios) }
  let(:id_usuario) { '141733544' }
  let(:caso_de_uso) { described_class.new(repositorio) }
  let(:usuario_esperado) { instance_double(Usuario, id: id_usuario, nombre: 'test', email: 'test@gmail.com') }

  it 'se registra un usuario con los datos correctos' do
    allow(repositorio).to receive(:guardar).and_return(usuario_esperado)

    resultado = caso_de_uso.ejecutar(id_usuario, 'test', 'test@gmail.com')

    expect(resultado).to eq(usuario_esperado)
  end
end
