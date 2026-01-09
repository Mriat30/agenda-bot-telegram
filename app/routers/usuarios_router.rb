require "#{File.dirname(__FILE__)}/../../lib/routing"
require_relative '../vistas/vista_registracion'

class UsuariosRouter
  include Routing

  def tiene_registracion_pendiente?(id)
    self.class.tiene_registracion_pendiente?(id)
  end

  def procesar_paso_registracion(bot, message)
    self.class.procesar_paso_registracion(bot, message)
  end

  def mostrar_bienvenida(bot, message)
    VistaRegistracion.new(bot, message).bienvenida
  end

  def initialize(logger, registrar_usuario_caso_de_uso)
    self.class.logger = logger
    self.class.registrar_usuario_caso_de_uso = registrar_usuario_caso_de_uso
    self.class.estados_usuario ||= {}
  end

  class << self
    attr_accessor :estados_usuario, :logger, :registrar_usuario_caso_de_uso

    def set_pending(id, data)
      @estados_usuario ||= {}
      @estados_usuario[id] = data
    end

    def pending_for(id)
      @estados_usuario ||= {}
      @estados_usuario[id]
    end

    def clear_pending(id)
      @estados_usuario ||= {}
      @estados_usuario.delete(id)
    end

    def tiene_registracion_pendiente?(id)
      !pending_for(id).nil?
    end

    # rubocop:disable Metrics/AbcSize
    def procesar_paso_registracion(bot, message)
      id = message.chat.id
      state = pending_for(id)
      return false unless state

      vista = VistaRegistracion.new(bot, message)

      case state[:step]
      when :waiting_name
        set_pending(id, { step: :waiting_lastname, nombre: message.text })
        vista.pedir_apellido
        true
      when :waiting_lastname
        set_pending(id, state.merge(step: :waiting_phone, apellido: message.text))
        vista.pedir_telefono
        true
      when :waiting_phone
        set_pending(id, state.merge(step: :waiting_address, telefono: message.text))
        vista.pedir_domicilio
        true
      when :waiting_address
        state_final = state.merge(domicilio: message.text)
        finalizar_registro(bot, message, state_final, vista)
        true
      else
        false
      end
    end
    # rubocop:enable Metrics/AbcSize

    def finalizar_registro(_bot, message, state, vista)
      intentar_registro(message.chat.id, state, vista)
    end

    private

    def intentar_registro(chat_id, state, vista)
      registrar_usuario_caso_de_uso&.ejecutar(
        chat_id.to_s, state[:nombre], state[:apellido], state[:telefono], state[:domicilio]
      )
      finalizar_flujo_exitoso(chat_id, vista)
    rescue RepositorioUsuarios::ErrorDeConflicto => e
      finalizar_flujo_con_error(chat_id, vista, e.message)
    end

    def finalizar_flujo_exitoso(chat_id, vista)
      vista.registro_exitoso
      clear_pending(chat_id)
    end

    def finalizar_flujo_con_error(chat_id, vista, mensaje)
      vista.error_de_registro("⚠️ #{mensaje}")
      clear_pending(chat_id)
    end
  end

  on_response_to 'Hola! Soy el asistente de Valeria Sapulia...' do |bot, message|
    if message.data == 'register'
      id = message.message.chat.id
      UsuariosRouter.set_pending(id, { step: :waiting_name })
      VistaRegistracion.new(bot, message).pedir_nombre
    end
  end
end
