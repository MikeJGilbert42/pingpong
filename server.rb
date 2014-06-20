#!/usr/bin/env ruby
require 'eventmachine'
require 'json'

class Game < EventMachine::Connection
  def post_init
    puts 'Got connection.'
    send_client({ message: 'ready' })
  end

  def receive_data(message)
    begin
      data = JSON.parse(message).to_h
    rescue JSON::ParseError => e
      send_client({ error: 'could not parse response.' })
    end
    puts "Got response", data
  end

  def send_client h
    send_data h.to_json
  end
end

puts "Starting server..."

begin
  EventMachine::run do
    EventMachine::start_server '127.0.0.1', 8081, Game
    puts "Running on port 8081."
  end
ensure
  puts ""
  puts "Shutting down."
end
