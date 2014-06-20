require 'eventmachine'
require 'json'

class Client < EventMachine::Connection
  def post_init
    send_server({ message: 'hello' })
  end

  def receive_data(message)
    data = JSON.parse(message).to_h
    puts "Got response", data
  end

  def send_server h
    send_data h.to_json
  end
end

EventMachine.run {
  EventMachine::connect '127.0.0.1', 8081, Client
}
