require "spec_helper"

describe Player do
  it "has a name" do
    Player.new("Mike").name.should == "Mike"
  end
end
