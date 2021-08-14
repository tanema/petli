module Petli
  module Rooms
    class Guess < Room
      def actions
        %w(left right)
      end

      def keypress(event)
        goto("main")
      end
    end
  end
end
