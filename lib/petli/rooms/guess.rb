module Petli
  module Rooms
    class Guess < Room
      def initialize(pet)
        super(pet)
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
        pet.reset
      end

      def keypress(event)
        return if event.value != "l" and event.value != "r"
        @petpickedleft = rand(1..2) == 1
        @pickedleft = event.value == "l"
        (@petpickedleft == @pickedleft) ? @pet.celebrate : @pet.embarass
        @countdown = 20
      end

      def draw(ctx, ox, oy)
        ctx.render_at(ox+9, oy+4, @pet.display)
        if @countdown == -1
          ctx.render_at(ox+4, oy+5, "☟") if @left
          ctx.render_at(ox+23, oy+5, "☟") unless @left
          ctx.render_at(ox+4, oy+6, "▒") if @left
          ctx.render_at(ox+23, oy+6, "▒") unless @left
          @left = !@left
        elsif @countdown == 0
          (@petpickedleft == @pickedleft) ? @pet.win : @pet.lose
          goto("main")
        else
          ctx.render_at(ox+4, oy+5, "☟") if @pickedleft
          ctx.render_at(ox+23, oy+5, "☟") unless @pickedleft
          ctx.render_at(ox+4, oy+6, "▒") if @petpickedleft
          ctx.render_at(ox+23, oy+6, "▒") unless @petpickedleft
          @countdown -= 1
        end
      end
    end
  end
end
