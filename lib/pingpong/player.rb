module PingPong
  class Player
    attr_reader :name, :score

    def initialize(name)
      @name = name
      @score = 0
    end

    def serve
      result = [:let, :miss, :success].sample

      case result
      when :let
        PingPong::IO.puts "#{self} has hit the net and will re-serve."
        serve
      when :miss
        PingPong::IO.puts "Ohs noes! The serve went out!"
        false
      else
        PingPong::IO.puts "#{self} serves an awesome shot!"
        true
      end
    end

    def score!
      @score += 1
    end

    def to_s
      name
    end
  end
end
