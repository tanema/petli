module Petli
  module Stages
    class Play < Base
      def actions
        {
          guess: -> {goto(Guess, pet: @pet)},
          dice: -> {goto(Dice, pet: @pet)},
          else: -> {goto(Main, pet: @pet)},
        }
      end
    end
  end
end

