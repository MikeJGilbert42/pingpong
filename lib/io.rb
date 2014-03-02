module PingPong
  class IO
    class << self
      def puts(msg)
        STDOUT.puts msg
      end

      def gets
        STDIN.gets
      end
    end
  end
end
