require "spec_helper"

describe PingPong::Game do
  let(:player1) { PingPong::Player.new("Mike VS") }
  let(:player2) { PingPong::Player.new("Mike G") }
  let(:game) { PingPong::Game.new player1, player2 }

  it "allows the players to be passed in" do
    game = PingPong::Game.new player1, player2
    game.player1.name.should == "Mike VS"
    game.player2.name.should == "Mike G"
    game.current_player.should == game.player1
  end

  it "initializes the players" do
    PingPong::IO.stub(:gets).and_return("MVS", "G")
    game = PingPong::Game.new
    game.player1.name.should == "MVS"
    game.player2.name.should == "G"
    game.current_player.should == game.player1
  end

  describe "#coin_flip!" do
    it "sets the first current player" do
      Array.any_instance.stub(:sample).and_return(player1)
      game.coin_flip!
      game.current_player.should == player1

      Array.any_instance.stub(:sample).and_return(player2)
      game.coin_flip!
      game.current_player.should == player2
    end
  end

  describe "#other_player" do
    it "returns the non-current player" do
      game.other_player.should == player2
    end

    it "can take a player and return the other player" do
      game.other_player(player1).should == player2
      game.other_player(player2).should == player1
    end
  end

  describe "#total_score" do
    it "returns the initial score initially" do
      game.total_score.should == 0
    end

    it "returns the updated score as it changes" do
      player1.score!
      player1.score!
      player2.score!
      game.total_score.should == 3
      player1.score!
      game.total_score.should == 4
    end
  end

  describe "#has_winner?" do
    it "is false initially" do
      game.has_winner?.should be_false
    end

    it "is false with some arbitrary score" do
      15.times { player1.score! }
      12.times { player2.score! }
      game.has_winner?.should be_false
    end

    it "is true if player 1 has 21 points" do
      21.times { player1.score! }
      15.times { player2.score! }
      game.has_winner?.should be_true
    end

    it "is true if player 2 has 21 points" do
      15.times { player1.score! }
      21.times { player2.score! }
      game.has_winner?.should be_true
    end

    it "is false if a player isn't winning by 2" do
      20.times { player1.score! }
      21.times { player2.score! }
      game.has_winner?.should be_false
    end

    it "is true if a player is winning by 2 past 21" do
      20.times { player1.score! }
      21.times { player2.score! }
      player1.score!
      player2.score!
      player2.score!
      game.has_winner?.should be_true
    end
  end

  describe "#winner" do
    it "returns nil when there is no winner" do
      game.winner.should == nil

      15.times { player1.score! }
      12.times { player2.score! }
      game.winner.should == nil
    end

    it "returns player 1 when they are the winner" do
      21.times { player1.score! }
      15.times { player2.score! }
      game.winner.should == player1
    end

    it "returns player 2 when they are the winner" do
      15.times { player1.score! }
      21.times { player2.score! }
      game.winner.should == player2
    end
  end

  describe "#round!" do
    it "scores for the other player when the current player missess the serve" do
      Array.any_instance.stub(:sample).and_return(:miss)
      game.round!
      player1.score.should == 0
      player2.score.should == 1
    end

    it "scores for the current player when the current player hits and the other player misses" do
      results = [:hit, :miss]
      Array.any_instance.stub(:sample) { results.shift }

      game.round!
      player1.score.should == 1
      player2.score.should == 0
    end

    it "scores for the other player when the current player hits and the other player hits and then the current player misses" do
      results = [:hit, :hit, :miss]
      Array.any_instance.stub(:sample) { results.shift }

      game.round!
      player1.score.should == 0
      player2.score.should == 1
    end

    it "reserves when the player let's" do
      results = [:let, :hit, :hit, :miss]
      Array.any_instance.stub(:sample) { results.shift }

      game.round!
      player1.score.should == 0
      player2.score.should == 1
    end
  end
end
