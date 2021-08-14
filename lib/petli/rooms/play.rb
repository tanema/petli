module Petli
  module Rooms
    class Play < Room
      def actions
        %w(guess dice)
      end

      def keypress(event)
        return goto("dice") if event.value == "d"
        return goto("guess") if event.value == "g"
        goto("main")
      end
    end
  end
end

