require 'dotenv/load'
require 'webrick'
require "#{File.dirname(__FILE__)}/app/bot_client"

$stdout.sync = true

Thread.new do
  begin
    port = ENV['PORT'] || 10000
    server = WEBrick::HTTPServer.new(
      Port: port,
      Logger: WEBrick::Log.new(File::NULL), # No ensucia los logs
      AccessLog: []
    )
    server.mount_proc('/') { |_req, res| res.body = 'Bot is running' }
    puts "Servidor de monitoreo iniciado en puerto #{port}"
    server.start
  rescue => e
    puts "Error en el servidor web de monitoreo: #{e.message}"
  end
end

puts "Iniciando BotClient..."
BotClient.new.start
