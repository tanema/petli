module Petli
  module Stages
    class Main < Base
      def actions
        acts = %w(play feed)
        acts << "clean" if @pet.poops.count > 0
        acts
      end

      def onkey(event)
        return goto(Feed, pet: @pet) if event.value == "f"
        return @pet.clean if event.value == "c"
        return goto(Play, pet: @pet) if event.value == "p"
      end
    end
  end
end
