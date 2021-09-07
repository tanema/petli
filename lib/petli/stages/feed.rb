module Petli
  module Stages
    class Feed < Base
      def actions
        %w(bread snack med)
      end

      def onkey(event)
        if event.value == "b"
          @pet.feed(food: :bread)
        elsif event.value == "s"
          @pet.feed(food: :candy)
        elsif event.value == "m"
          @pet.feed(food: :medicine)
        end
        goto(Main, pet: @pet)
      end
    end
  end
end
