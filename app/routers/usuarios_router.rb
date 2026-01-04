require "#{File.dirname(__FILE__)}/../../lib/routing"

class UsuariosRouter
  include Routing

  def self.construir(logger, registrar_usuario_caso_de_uso)
    @logger = logger
    @registrar_usuario_caso_de_uso = registrar_usuario_caso_de_uso
  end

  class << self
    attr_reader :logger, :registrar_usuario_caso_de_uso
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
      bot.api.send_message(
        chat_id: message.message.chat.id,
        text: '¿Podrias decirme tu nombre?',
        reply_markup: Telegram::Bot::Types::ForceReply.new(force_reply: true)
      )
    end
  end

  on_reply_to '¿Podrias decirme tu nombre?' do |bot, message|
    bot.api.send_message(
      chat_id: message.chat.id,
      text: 'Por favor, decime tu apellido',
      reply_markup: Telegram::Bot::Types::ForceReply.new(force_reply: true)
    )
  end

  on_reply_to 'Por favor, decime tu apellido' do |bot, message|
    bot.api.send_message(
      chat_id: message.chat.id,
      text: 'Por favor, decime tu telefono',
      reply_markup: Telegram::Bot::Types::ForceReply.new(force_reply: true)
    )
  end

  on_reply_to 'Por favor, decime tu telefono' do |bot, message|
    bot.api.send_message(
      chat_id: message.chat.id,
      text: 'Por favor, decime tu domicilio',
      reply_markup: Telegram::Bot::Types::ForceReply.new(force_reply: true)
    )
  end

  on_reply_to 'Por favor, decime tu domicilio' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: 'Perfecto, ya registre tus datos!')
  end
end
