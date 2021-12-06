module Petli
  module Stages
    class Feed < Base
      def actions
        {
          bread: -> {feed(:bread)},
          snack: -> {feed(:candy)},
          med:   -> {feed(:medicine)},
          else:  -> {goto(Main, pet: @pet)},
        }
      end

      def feed(food)
        @pet.feed(food: food)
        goto(Main, pet: @pet)
      end
    end
  end
end
