class VistaBase
  attr_reader :bot, :message

  def initialize(bot, message)
    @bot = bot
    @message = message
  end

  def chat_id
    if message.is_a?(Telegram::Bot::Types::CallbackQuery)
      message.message.chat.id
    else
      message.chat.id
    end
  end

  def mandar_mensaje(text, options = {})
    bot.api.send_message(options.merge(chat_id:, text:))
  end

  def crear_boton(text, callback_data)
    Telegram::Bot::Types::InlineKeyboardButton.new(
      text:,
      callback_data:
    )
  end

  def crear_teclado(filas)
    Telegram::Bot::Types::InlineKeyboardMarkup.new(
      inline_keyboard: filas
    )
  end
end
