require "spec_helper"

describe Player do
  let(:player) { Player.new "Mike" }

  it "has a name" do
    player.name.should == "Mike"
  end

  it "has a score" do
    player.score.should == 0
  end

  it "can score" do
    player.score!
    player.score.should == 1
  end

  its "to_s returns it's name" do
    player.to_s.should == player.name
  end
end
