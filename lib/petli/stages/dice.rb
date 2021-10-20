module Petli
  module Stages
    class Dice < Base
      Symbols = %w(⚀ ⚁ ⚂ ⚃ ⚄ ⚅)

      def initialize(pet:)
        super(pet: pet)
        @value = rand(1..6)
        @countdown = -1
      end

      def actions
        %w(higher lower)
      end

      def enter
        @pet.play(game: :guess)
      end

      def leave
        @pet.reset
      end

      def roll
      end

      def onkey(event)
        return if event.value != "h" and event.value != "l"
        @pickedhigher = event.value == "h"
        @pick = (1..6).to_a.sample
        @won = (event.value == "h" && @pick > @value) || (event.value == "l" && @pick < @value)
        @won ? @pet.celebrate : @pet.embarass
        @countdown = 10
      end

      def draw
        super
        if @countdown == -1
          render_at(left+4, top+6, @value.to_s)
          render_at(left+23, top+6, Symbols[(0..5).to_a.sample])
        elsif @countdown == 0
          @won ? @pet.win : @pet.lose
          goto(Main, pet: @pet)
        else
          render_at(left+4, top+5, "▲") if @pickedhigher
          render_at(left+4, top+6, @value.to_s)
          render_at(left+23, top+6, Symbols[@pick-1])
          render_at(left+4, top+7, "▼") unless @pickedhigher
          @countdown -= 1
        end
      end
    end
  end
end
