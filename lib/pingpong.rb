require_relative "pingpong/ball.rb"
require_relative "pingpong/game.rb"
require_relative "pingpong/io.rb"
require_relative "pingpong/player.rb"

module PingPong
  class << self
    def run
      game = PingPong::Game.new
      game.coin_flip!
      game.round! until game.has_winner?
    end
  end
end
