module Petli
  module Rooms
    class Dice < Room
      Symbols = %w(⚀ ⚁ ⚂ ⚃ ⚄ ⚅)

      def initialize(pet)
        super(pet)
        @value = rand(1..6)
        @countdown = -1
      end

      def actions
        %w(higher lower)
      end

      def enter
        pet.play(game: :guess)
      end

      def leave
        pet.reset
      end

      def roll
      end

      def keypress(event)
        return if event.value != "h" and event.value != "l"
        @pickedhigher = event.value == "h"
        @pick = (1..6).to_a.sample
        @won = (event.value == "h" && @pick > @value) || (event.value == "l" && @pick < @value)
        @won ? @pet.celebrate : @pet.embarass
        @countdown = 20
      end

      def draw(ctx, ox, oy)
        ctx.render_at(ox+9, oy+4, @pet.display)
        if @countdown == -1
          ctx.render_at(ox+4, oy+6, @value.to_s)
          ctx.render_at(ox+23, oy+6, Symbols[(0..5).to_a.sample])
        elsif @countdown == 0
          @won ? @pet.win : @pet.lose
          goto("main")
        else
          ctx.render_at(ox+4, oy+5, "▲") if @pickedhigher
          ctx.render_at(ox+4, oy+6, @value.to_s)
          ctx.render_at(ox+23, oy+6, Symbols[@pick-1])
          ctx.render_at(ox+4, oy+7, "▼") unless @pickedhigher
          @countdown -= 1
        end
      end
    end
  end
end
