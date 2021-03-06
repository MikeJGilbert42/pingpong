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
      miss_serve! player1
      game.round!
      player1.score.should == 0
      player2.score.should == 1
    end

    it "scores for the current player when the current player hits and the other player misses" do
      hit_serve! player1
      miss_return! player2
      game.round!
      player1.score.should == 1
      player2.score.should == 0
    end

    it "scores for the other player when the current player hits and the other player hits and then the current player misses" do
      hit_serve! player1
      hit_return! player2
      miss_return! player1
      results = [:hit, :hit, :miss]
      Array.any_instance.stub(:sample) { results.shift }

      game.round!
      player1.score.should == 0
      player2.score.should == 1
    end

    it "reserves when the player let's" do
      let_serve! player1
      hit_serve! player1
      hit_return! player2
      miss_return! player1
      game.round!
      player1.score.should == 0
      player2.score.should == 1
    end

    it "doesn't change server for the first 4 points" do
      player1_score! game
      game.round!
      game.current_player.should == game.player1

      player2_score! game
      game.round!
      game.current_player.should == game.player1

      player1_score! game
      game.round!
      game.current_player.should == game.player1

      player1_score! game
      game.round!
      game.current_player.should == game.player1
    end

    it "alternates server every 5 points" do
      player1_score! game
      game.round!

      player1_score! game
      game.round!

      player1_score! game
      game.round!

      player2_score! game
      game.round!
      game.current_player.should == game.player1

      player2_score! game
      game.round!
      game.current_player.should == game.player2

      player2_score! game
      game.round!
      player1_score! game
      game.round!
      player1_score! game
      game.round!
      player2_score! game
      game.round!

      player1_score! game
      game.round!
      game.current_player.should == game.player1
    end

    it "alternates every serve when in deuce" do
      20.times do
        player1_score! game
        game.round!
      end

      14.times do
        player2_score! game
        game.round!
      end

      game.current_player.should == player1

      5.times do
        player2_score! game
        game.round!
        game.current_player.should == player2
      end

      player2_score! game
      game.round!
      game.current_player.should == player1
      player1.score.should == 20
      player2.score.should == 20

      player2_score! game
      game.round!
      game.current_player.should == player2

      player1_score! game
      game.round!
      game.current_player.should == player1

      player2_score! game
      game.round!
      game.current_player.should == player2

      player1_score! game
      game.round!
      game.current_player.should == player1

      player1_score! game
      game.round!
      game.current_player.should == player2
    end
  end

  describe "#score_message" do
    it "shows normal score for pre-deuce scoring" do
      game.score_message.should == "The score is Mike VS: 0 - Mike G: 0"

      4.times { player1.score! }
      2.times { player2.score! }
      game.score_message.should == "The score is Mike VS: 4 - Mike G: 2"

      10.times { player1.score! }
      10.times { player2.score! }
      game.score_message.should == "The score is Mike VS: 14 - Mike G: 12"
    end

    it "shows deuce scoring" do
      20.times { player1.score! }
      20.times { player2.score! }
      game.score_message.should == "The score is DEUCE (Mike VS: 20 - Mike G: 20)"

      player1.score!
      game.score_message.should == "The score is ADVANTAGE Mike VS (Mike VS: 21 - Mike G: 20)"

      player2.score!
      game.score_message.should == "The score is DEUCE (Mike VS: 21 - Mike G: 21)"

      player2.score!
      game.score_message.should == "The score is ADVANTAGE Mike G (Mike VS: 21 - Mike G: 22)"
    end

    it "shows the proper final score in post-deuce" do
      20.times { player1.score! }
      22.times { player2.score! }
      game.score_message.should == "The score is Mike VS: 20 - Mike G: 22"

      player2.score!
      5.times { player1.score! }
      game.score_message.should == "The score is Mike VS: 25 - Mike G: 23"
    end
  end
end
