require "#{File.dirname(__FILE__)}/../../lib/routing"
require_relative '../vistas/vista_registracion'

class UsuariosRouter
  include Routing

  @user_states = {}
  @logger = nil
  @registrar_usuario_caso_de_uso = nil

  class << self
    attr_accessor :user_states, :logger, :registrar_usuario_caso_de_uso
  end

  def initialize(logger, registrar_usuario_caso_de_uso)
    self.class.logger = logger
    self.class.registrar_usuario_caso_de_uso = registrar_usuario_caso_de_uso
    self.class.user_states = {} if self.class.user_states.nil? || self.class.user_states.empty?
  end

  on_message 'Hola' do |bot, message|
    VistaRegistracion.new(bot, message).bienvenida
  end

  on_response_to 'Hola! Soy el asistente de Valeria Sapulia...' do |bot, message|
    if message.data == 'register'
      id = VistaBase.new(bot, message).chat_id
      UsuariosRouter.user_states[id] = { step: :nombre }
      VistaRegistracion.new(bot, message).pedir_nombre
    end
  end

  on_message_pattern(/.*/) do |bot, message, _|
    id = message.chat.id
    state = UsuariosRouter.user_states[id]
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
    registrar_usuario_caso_de_uso&.ejecutar(
      message.chat.id.to_s, state[:nombre], state[:apellido], state[:telefono], state[:domicilio]
    )
    vista.registro_exitoso
    user_states.delete(message.chat.id)
  end
end
