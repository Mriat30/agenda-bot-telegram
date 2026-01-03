class Usuario
  attr_reader :id, :nombre, :apellido, :telefono, :domicilio

  def initialize(id, nombre, apellido, telefono, domicilio)
    @id = id
    @nombre = nombre
    @apellido = apellido
    @telefono = telefono
    @domicilio = domicilio
  end
end
