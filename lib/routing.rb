module Routing
  @message_handlers = {}
  @regex_message_handlers = {}
  @callback_query_handlers = {}
  @callback_location_handler = nil
  @reply_to_handlers = {}

  DEFAULT = '_default_handler_'.freeze

  def self.message_handlers
    @message_handlers
  end

  def self.regex_message_handlers
    @regex_message_handlers
  end

  def self.callback_query_handlers
    @callback_query_handlers
  end

  def self.callback_location_handler
    @callback_location_handler
  end

  def self.callback_location_handler=(handler)
    @callback_location_handler = handler
  end

  def self.reply_to_handlers
    @reply_to_handlers
  end

  def self.included(clazz)
    clazz.extend ClazzMethods
  end

  def handle(bot, message)
    handler = find_handler_for(message)
    handler, named_captures = find_regex_handler_for(message) if handler.nil?

    if !handler.nil?
      handler.call(bot, message, named_captures)
      true
    else
      default_h = Routing.message_handlers[DEFAULT]
      if default_h
        default_h.call(bot, message)
        return true
      end
      false
    end
  end

  module ClazzMethods
    def on_message(expected_message, &block)
      Routing.message_handlers[expected_message] = block
    end

    def on_message_pattern(expected_message_regex, &block)
      Routing.regex_message_handlers[expected_message_regex] = block
    end

    def on_response_to(expected_message, &block)
      Routing.callback_query_handlers[expected_message] = block
    end

    def on_reply_to(expected_message, &block)
      Routing.reply_to_handlers[expected_message] = block
    end

    def on_location_response(&block)
      Routing.callback_location_handler = block
    end

    def default(&block)
      Routing.message_handlers[DEFAULT] = block
    end
  end

  private

  def find_handler_for(message)
    case message
    when Telegram::Bot::Types::Message
      find_message_handler(message)
    when Telegram::Bot::Types::CallbackQuery
      Routing.callback_query_handlers[message.message.text]
    end
  end

  def find_message_handler(message)
    return Routing.callback_location_handler unless message.location.nil?

    handler = find_reply_to_handler(message)
    return handler if handler

    Routing.message_handlers[message.text]
  end

  def find_reply_to_handler(message)
    return nil unless message.reply_to_message&.text

    Routing.reply_to_handlers[message.reply_to_message.text]
  end

  def find_regex_handler_for(message)
    return [nil, nil] unless message.respond_to?(:text) && message.text

    message_text = message.text
    regex, handler = Routing.regex_message_handlers.find do |regex, _block|
      message_text =~ regex
    end
    return unless handler

    matches = message_text.match(regex)
    [handler, matches.named_captures]
  end

  def default_handler(message)
    Routing.message_handlers[DEFAULT] ||
      (raise "Unkown message [#{message.inspect}]. Please define new handler or a default handler")
  end
end
