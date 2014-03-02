module PingPong
  class Game
    attr_reader :player1, :player2, :current_player

    def initialize(player1 = nil, player2 = nil)
      @player1 = player1 || new_player(1)
      @player2 = player2 || new_player(2)
      @current_player = @player1
    end

    def coin_flip!
      PingPong::IO.puts "Press Enter for coin flip"
      PingPong::IO.gets
      @current_player = [player1, player2].sample
      PingPong::IO.puts "#{current_player} has won the toss!"
    end

    def round!
      PingPong::IO.puts "Press Enter to serve as #{current_player}"
      PingPong::IO.gets

      ok = current_player.serve
      other_player.score! unless ok
      current_player.score! if ok

#      until missed
#      end

      PingPong::IO.puts "The score is #{player1}: #{player1.score} - #{player2}: #{player2.score}"
      change_possession! if total_score % 5 == 0
    end

    def winner
      return nil unless has_winner?
      [player1, player2].max_by(&:score)
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
    def new_player(num)
      PingPong::IO.puts "What is player #{num}\'s name?"
      PingPong::Player.new PingPong::IO.gets.strip
    end

    def is_winner?(p1, p2)
      p1.score >= 21 && p1.score - p2.score >= 2
    end

    def change_possession!
      @current_player = other_player
    end
  end
end
