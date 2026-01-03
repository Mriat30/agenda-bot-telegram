class Usuario
  attr_reader :id, :nombre, :email

  def initialize(id, nombre, email)
    @id = id
    @nombre = nombre
    @email = email
  end
end
