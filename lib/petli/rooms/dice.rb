module Petli
  module Rooms
    class Dice < Room
      def actions
        %w(higher lower)
      end

      def keypress(event)
        goto("main")
      end
    end
  end
end
