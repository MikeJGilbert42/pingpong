require_relative "../lib/pingpong.rb"
Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.before :each do
    PingPong::IO.stub(:gets).and_return("UNHANDLED")
    PingPong::IO.stub(:puts).and_return(nil)
  end
end
