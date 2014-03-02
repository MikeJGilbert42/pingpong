module PingPong
  class Ball
    attr_accessor :possessor

    def initialize(possessor)
      @possessor = possessor
    end

    def hit!
      @missed = false
    end

    def miss!
      @missed = true
    end

    def missed?
      @missed
    end
  end
end
