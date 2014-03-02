module PlayerHits
  def hit_serve!(player)
    player.should_receive(:do_serve).and_return(:hit)
  end

  def miss_serve!(player)
    player.should_receive(:do_serve).and_return(:miss)
  end

  def let_serve!(player)
    player.should_receive(:do_serve).and_return(:let)
  end

  def hit_return!(player)
    player.should_receive(:do_hit).and_return(:hit)
  end

  def miss_return!(player)
    player.should_receive(:do_hit).and_return(:miss)
  end
end

RSpec.configure do |config|
  config.include PlayerHits
end
