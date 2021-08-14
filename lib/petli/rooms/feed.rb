module Petli
  module Rooms
    class Feed < Room
      def actions
        %w(bread snack med)
      end

      def keypress(event)
        if event.value == "b"
          @pet.feed(food: :bread)
        elsif event.value == "s"
          @pet.feed(food: :candy)
        elsif event.value == "m"
          @pet.feed(food: :medicine)
        end
        goto("main")
      end
    end
  end
end
