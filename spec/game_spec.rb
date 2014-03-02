require "spec_helper"

describe PingPong::Game do
  let(:player1) { PingPong::Player.new("Mike VS") }
  let(:player2) { PingPong::Player.new("Mike G") }

  it "allows the players to be passed in" do
    game = PingPong::Game.new player1, player2
    game.player1.name.should == "Mike VS"
    game.player2.name.should == "Mike G"
  end

  it "initializes the players" do
    PingPong::IO.stub(:gets).and_return("MVS", "G")
    game = PingPong::Game.new
    game.player1.name.should == "MVS"
    game.player2.name.should == "G"
  end
end
