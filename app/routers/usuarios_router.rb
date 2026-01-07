require "#{File.dirname(__FILE__)}/../../lib/routing"
require_relative '../vistas/vista_registracion'

class UsuariosRouter
  include Routing

  @estados_usuario = {}
  @logger = nil
  @registrar_usuario_caso_de_uso = nil

  class << self
    attr_accessor :estados_usuario, :logger, :registrar_usuario_caso_de_uso
  end

  def initialize(logger, registrar_usuario_caso_de_uso)
    self.class.logger = logger
    self.class.registrar_usuario_caso_de_uso = registrar_usuario_caso_de_uso
    self.class.estados_usuario = {} if self.class.estados_usuario.nil? || self.class.estados_usuario.empty?
  end

  on_message 'Hola' do |bot, message|
    VistaRegistracion.new(bot, message).bienvenida
  end

  on_response_to 'Hola! Soy el asistente de Valeria Sapulia...' do |bot, message|
    if message.data == 'register'
      id = VistaBase.new(bot, message).chat_id
      UsuariosRouter.estados_usuario[id] = { step: :nombre }
      VistaRegistracion.new(bot, message).pedir_nombre
    end
  end

  on_message_pattern(/.*/) do |bot, message, _|
    id = message.chat.id
    state = UsuariosRouter.estados_usuario[id]
    next unless state

    vista = VistaRegistracion.new(bot, message)
    pasos = {
      nombre: [:apellido, 'apellido'],
      apellido: [:telefono, 'telefono'],
      telefono: [:domicilio, 'domicilio']
    }

    if pasos.key?(state[:step])
      proximo, etiqueta = pasos[state[:step]]
      state[state[:step]] = message.text
      state[:step] = proximo
      vista.pedir_dato(etiqueta)
    elsif state[:step] == :domicilio
      finalizar_registro(bot, message, state, vista)
    end
  end

  def self.finalizar_registro(_bot, message, state, vista)
    state[:domicilio] = message.text
    intentar_registro(message.chat.id, state, vista)
  end

  private_class_method def self.intentar_registro(chat_id, state, vista)
    registrar_usuario_caso_de_uso&.ejecutar(
      chat_id.to_s, state[:nombre], state[:apellido], state[:telefono], state[:domicilio]
    )
    finalizar_flujo_exitoso(chat_id, vista)
  rescue RepositorioUsuarios::ErrorDeConflicto => e
    finalizar_flujo_con_error(chat_id, vista, e.message)
  end

  private_class_method def self.finalizar_flujo_exitoso(chat_id, vista)
    vista.registro_exitoso
    estados_usuario.delete(chat_id)
  end

  private_class_method def self.finalizar_flujo_con_error(chat_id, vista, mensaje)
    vista.error_de_registro("⚠️ #{mensaje}")
    estados_usuario.delete(chat_id)
  end
end
