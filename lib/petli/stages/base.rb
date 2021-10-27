require 'pastel'

module Petli
  module Stages
    class Base < Tatty::Stage
      GAME_WIDTH = 28
      GAME_HEIGHT = 13

      def initialize(pet:)
        super()
        @pet = pet
        @poop = Tatty::Anim.from_atlas('./data/poop.txtanim')
      end

      def keypress(event)
        exit if event.value == "q" || event.value == "\e" || event.value == "x"
        return if @pet.busy? || @pet.dead?
        onkey(event)
      end

      def actions
        %w()
      end

      def action_bar
        return "" if @pet.dead? || @pet.busy?
        p = Pastel.new
        self.actions.map do |a|
          key = p.bold("[#{a[0].capitalize}]")
          "#{key}#{a[1..]}"
        end.join(" ")
      end

      def left
        ((screen_width-GAME_WIDTH)/2).round
      end

      def top
        ((screen_height-GAME_HEIGHT)/2).round
      end

      def draw
        p = Pastel.new
        render_box(
          title: {
            top_left: p.bright_white.bold(" Petli "),
            bottom_right: p.green(" #{@pet.lifetime} days "),
          },
          width: GAME_WIDTH,
          height: GAME_HEIGHT,
          left: left,
          top: top,
        )

        poop = @poop.next
        @pet.poops.each_with_index do |_, i|
          x, y = Pet::POOP_LOCATIONS[i]
          render_at(left+1+x, top+1+y, poop)
        end

        render_at(left+9, top+4, @pet.display)
        sick = @pet.sick
        if sick > 0 && !@pet.dead?
          render_at(left+11-sick, top+4, "[#{'!'*sick}SICK#{'!'*sick}]")
        end

        render_at(left+1, top+1, "#{p.red("♥")*@pet.health}#{"♡"*(10-@pet.health)}      #{"☺"*(10-@pet.happiness)}#{p.green("☻")*@pet.happiness}")
        render_at(left+1, top+GAME_HEIGHT-2, self.action_bar)
        render_at(left+GAME_WIDTH-2, top, p.bright_white.bold("[x]"))
      end
    end
  end
end
