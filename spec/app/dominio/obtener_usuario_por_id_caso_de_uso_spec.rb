require 'spec_helper'
require_relative '../../../app/dominio/obtener_usuario_por_id_caso_de_uso'

describe ObtenerUsuarioPorIdCasoDeUso do
  let(:repositorio) { instance_double(RepositorioUsuarios) }
  let(:caso_de_uso) { described_class.new(repositorio) }
  let(:usuario_esperado) do
    instance_double(Usuario,
                    id: '141733544',
                    nombre: 'test',
                    apellido: 'sito',
                    telefono: '1234567899',
                    domicilio: 'Esquel 770')
  end

  it 'dado que existe un usuario registrado obtener un usuario por id devuelve el usuario' do
    allow(repositorio).to receive(:encontrar_por_id).and_return(usuario_esperado)

    expect(caso_de_uso.ejecutar('141733544')).to eq(usuario_esperado)
  end
end
