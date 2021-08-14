module Petli
  module Rooms
    class Main < Room
      def actions
        acts = %w(play feed)
        acts << "clean" if @pet.poops.count > 0
        acts
      end

      def keypress(event)
        return goto("feed") if event.value == "f"
        return @pet.clean if event.value == "c"
        return goto("play") if event.value == "p"
      end
    end
  end
end
