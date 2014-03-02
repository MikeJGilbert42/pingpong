require "spec_helper"

describe PingPong::Ball do
  let(:ball) { PingPong::Ball.new player1 }
  let(:player1) { PingPong::Player.new "Mike" }

  it "knows the possessor" do
    ball = PingPong::Ball.new player1
    ball.possessor.should == player1
  end

  it "knows if it missed" do
    ball.hit!
    ball.missed?.should be_false
  end

  it "knows if it hit" do
    ball.miss!
    ball.missed?.should be_true
  end
end
