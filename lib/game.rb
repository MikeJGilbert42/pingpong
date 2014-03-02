class Game
  attr_accessor :player1, :player2, :current_player

  def initialize
  end

  def coin_flip!
    puts "Press Enter for coin flip"
    gets
    @current_player = [player1, player2].sample
    puts "#{current_player} has won the toss!"
  end

  def round!
    puts "Press Enter to serve as #{current_player}"
    gets

    ok = current_player.serve
    other_player.score! unless ok
    current_player.score! if ok
#
#    until missed
#    end

    puts "The score is #{player1}: #{player1.score} - #{player2}: #{player2.score}"
    change_possession! if total_score % 5 == 0
  end

  def winner
    [player1, player2].sort_by(&:score).last
  end

  def has_winner?
    is_winner?(player1, player2) || is_winner?(player2, player1)
  end

  def total_score
    player1.score + player2.score
  end

  def other_player
    if current_player == player1
      player2
    else
      player1
    end
  end

  private
  def is_winner?(p1, p2)
    p1.score >= 21 && p1.score - p2.score >= 2
  end

  def change_possession!
    @current_player = other_player
  end
end
