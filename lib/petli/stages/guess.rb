module Petli
  module Stages
    class Guess < Base
      def initialize(pet:)
        super(pet: pet)
        @left = true
        @countdown = -1
      end

      def actions
        %w(left right)
      end

      def enter
        pet.play(game: :guess)
      end

      def leave
        @pet.reset
      end

      def onkey(event)
        return if event.value != "l" and event.value != "r"
        @petpickedleft = rand(1..2) == 1
        @pickedleft = event.value == "l"
        (@petpickedleft == @pickedleft) ? @pet.celebrate : @pet.embarass
        @countdown = 20
      end

      def draw
        super
        if @countdown == -1
          render_at(left+4, top+5, "☟") if @left
          render_at(left+23, top+5, "☟") unless @left
          render_at(left+4, top+6, "▒") if @left
          render_at(left+23, top+6, "▒") unless @left
          @left = !@left
        elsif @countdown == 0
          (@petpickedleft == @pickedleft) ? @pet.win : @pet.lose
          goto(Main, pet: @pet)
        else
          render_at(left+4, top+5, "☟") if @pickedleft
          render_at(left+23, top+5, "☟") unless @pickedleft
          render_at(left+4, top+6, "▒") if @petpickedleft
          render_at(left+23, top+6, "▒") unless @petpickedleft
          @countdown -= 1
        end
      end
    end
  end
end
