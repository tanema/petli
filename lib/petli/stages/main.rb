module Petli
  module Stages
    class Main < Base
      def actions
        return %w(light) if @pet.lights_out
        acts = %w(play feed light)
        acts << "clean" if @pet.poops.count > 0
        acts
      end

      def onkey(event)
        return @pet.light_switch if event.value == "l"
        return if @pet.lights_out
        return goto(Feed, pet: @pet) if event.value == "f"
        return @pet.clean if event.value == "c"
        return goto(Play, pet: @pet) if event.value == "p"
      end
    end
  end
end
