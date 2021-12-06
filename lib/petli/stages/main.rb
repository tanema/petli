module Petli
  module Stages
    class Main < Base
      def actions
        return {light: -> {@pet.light_switch}} if @pet.lights_out
        acts = {
          play: -> {goto(Play, pet: @pet)},
          feed: -> {goto(Feed, pet: @pet)},
          light: -> {@pet.light_switch},
        }
        acts[:clean] = -> {@pet.clean} if @pet.poops.count > 0
        acts
      end
    end
  end
end
