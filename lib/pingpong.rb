require_relative "game.rb"
require_relative "io.rb"
require_relative "player.rb"

module PingPong
  class << self
    def run
      game = Game.new
      game.coin_flip!
      game.round! until game.has_winner?
    end
  end
end
