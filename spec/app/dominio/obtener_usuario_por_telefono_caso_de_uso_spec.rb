require 'spec_helper'
require "#{File.dirname(__FILE__)}/../../../app/dominio/obtener_usuario_por_telefono_caso_de_uso"
require "#{File.dirname(__FILE__)}/../../../app/repositorios/repositorio_usuarios"
require "#{File.dirname(__FILE__)}/../../../modelo/usuario"

describe ObtenerUsuarioPorTelefonoCasoDeUso do
  let(:repositorio) { instance_double(RepositorioUsuarios) }
  let(:id_usuario) { '141733544' }
  let(:caso_de_uso) { described_class.new(repositorio) }
  let(:usuario_esperado) do
    instance_double(Usuario,
                    id: id_usuario,
                    nombre: 'test',
                    apellido: 'sito',
                    telefono: '1234567899',
                    domicilio: 'Esquel 770')
  end

  it 'dado que existe un usuario registrado, obtener un usuario por telefono devuelve el usuario correspondiente' do
    allow(repositorio).to receive(:encontrar_por_telefono).and_return(usuario_esperado)

    resultado = caso_de_uso.ejecutar('1234567899')

    expect(resultado).to eq(usuario_esperado)
  end
end
