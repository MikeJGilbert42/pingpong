require_relative "../lib/game.rb"
require_relative "../lib/io.rb"
require_relative "../lib/player.rb"

RSpec.configure do |config|
  config.before :each do
    PingPong::IO.stub(:gets).and_return("UNHANDLED")
    PingPong::IO.stub(:puts).and_return(nil)
  end
end
