require "#{File.dirname(__FILE__)}/../../lib/routing"

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
    kb = [[Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Registrarme', callback_data: 'register')]]
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)

    bot.api.send_message(
      chat_id: message.chat.id,
      text: 'Hola! Soy el asistente de Valeria Sapulia...',
      reply_markup: markup
    )
  end

  on_response_to 'Hola! Soy el asistente de Valeria Sapulia...' do |bot, message|
    if message.data == 'register'
      UsuariosRouter.user_states[message.message.chat.id] = { step: :nombre }
      bot.api.send_message(chat_id: message.message.chat.id, text: '¿Podrias decirme tu nombre?')
    end
  end

  on_message_pattern(/.*/) do |bot, message, _|
    state = UsuariosRouter.user_states[message.chat.id]
    next unless state

    pasos = { nombre: [:apellido, 'apellido'], apellido: [:telefono, 'telefono'], telefono: [:domicilio, 'domicilio'] }

    if pasos.key?(state[:step])
      proximo, texto = pasos[state[:step]]
      state[state[:step]] = message.text
      state[:step] = proximo
      bot.api.send_message(chat_id: message.chat.id, text: "Por favor, decime tu #{texto}")
    elsif state[:step] == :domicilio
      state[:domicilio] = message.text
      UsuariosRouter.registrar_usuario_caso_de_uso&.ejecutar(message.chat.id.to_s, state[:nombre], state[:apellido], state[:telefono], state[:domicilio])
      bot.api.send_message(chat_id: message.chat.id, text: 'Perfecto, ya registre tus datos!')
      UsuariosRouter.user_states.delete(message.chat.id)
    end
  end
end
