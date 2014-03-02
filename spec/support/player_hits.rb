module PlayerHits
  def hit_serve!(player)
    player.stub(:do_serve).and_return(:hit)
  end

  def miss_serve!(player)
    player.stub(:do_serve).and_return(:miss)
  end

  def let_serve!(player)
    player.stub(:do_serve).and_return(:let)
  end

  def hit_return!(player)
    player.stub(:do_hit).and_return(:hit)
  end

  def miss_return!(player)
    player.stub(:do_hit).and_return(:miss)
  end

  def player1_score!(game)
    if game.current_player == game.player1
      hit_serve! game.player1
      miss_return! game.player2
    else
      miss_serve! game.player1
    end
  end

  def player2_score!(game)
    if game.current_player == game.player2
      hit_serve! game.player2
      miss_return! game.player1
    else
      miss_serve! game.player2
    end
  end
end

RSpec.configure do |config|
  config.include PlayerHits
end
