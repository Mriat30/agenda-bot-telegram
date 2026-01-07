require_relative './vista_base'

class VistaRegistracion < VistaBase
  def bienvenida
    botones = [[crear_boton('Registrarme', 'register')]]
    markup = crear_teclado(botones)
    mandar_mensaje('Hola! Soy el asistente de Valeria Sapulia...', reply_markup: markup)
  end

  def pedir_nombre
    mandar_mensaje('¿Podrias decirme tu nombre?')
  end

  def pedir_dato(campo)
    mandar_mensaje("Por favor, decime tu #{campo}")
  end

  def registro_exitoso
    mandar_mensaje('Perfecto, ya registre tus datos!')
  end

  def error_de_registro(mensaje)
    mandar_mensaje(mensaje)
  end
end
