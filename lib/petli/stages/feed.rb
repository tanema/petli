module Petli
  module Stages
    class Feed < Base
      def actions
        acts = {
          bread: -> {feed(:bread)},
          snack: -> {feed(:candy)},
          else:  -> {goto(Main, pet: @pet)},
        }
        acts[:med] = -> {feed(:medicine)} if @pet.sick?
        acts
      end

      def feed(food)
        @pet.feed(food: food)
        goto(Main, pet: @pet)
      end
    end
  end
end
