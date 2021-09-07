module Petli
  module Stages
    class Play < Base
      def actions
        %w(guess dice)
      end

      def onkey(event)
        return goto(Dice, pet: @pet) if event.value == "d"
        return goto(Guess, pet: @pet) if event.value == "g"
        goto(Main, pet: @pet)
      end
    end
  end
end

