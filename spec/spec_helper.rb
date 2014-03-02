require_relative "../lib/pingpong.rb"

RSpec.configure do |config|
  config.before :each do
    PingPong::IO.stub(:gets).and_return("UNHANDLED")
    PingPong::IO.stub(:puts).and_return(nil)
  end
end
