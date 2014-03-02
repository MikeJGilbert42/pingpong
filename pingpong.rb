require File.expand_path("../lib/game.rb", __FILE__)
require File.expand_path("../lib/player.rb", __FILE__)

game = Game.new
puts "What is player 1's name?"
game.player1 = Player.new gets.strip
puts "What is player 2's name?"
game.player2 = Player.new gets.strip
game.coin_flip!
game.round! until game.has_winner?
