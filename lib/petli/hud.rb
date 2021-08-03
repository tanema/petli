require_relative '../tatty/game'

module Petli
  require_relative 'pet'

  class HUD < Tatty::Game
    GAME_WIDTH = 28
    GAME_HEIGHT = 13

    def initialize
      super()
      @pet = Pet.new
    end

    def keypress(event)
      if event.value == "q"
        exit
      end

      return if @pet.busy?

      if @isfeeding
        if event.value == "b"
          @pet.feed(food: :bread)
        elsif event.value == "s"
          @pet.feed(food: :candy)
        elsif event.value == "m"
          @pet.feed(food: :medicine)
        end
        @isfeeding = false
        return
      end

      if @isplaying
        if event.value == "d"
          @pet.play(game: :dice)
        elsif event.value == "g"
          @pet.play(game: :guess)
        end
        @isplaying = false
        return
      end

      if event.value == "f"
        @isfeeding = true
      elsif event.value == "c"
        @pet.clean
      elsif event.value == "p"
        @isplaying = true
      end
    end

    def draw
      h, w = self.screen_size
      left, top = ((w-GAME_WIDTH)/2).round, ((h-GAME_HEIGHT)/2).round
      render_box(
        title: {
          top_left: " Petli ",
          bottom_right: " #{@pet.lifetime} days ",
        },
        width: GAME_WIDTH,
        height: GAME_HEIGHT,
        left: left,
        top: top,
      )
      render_at(left+9, top+3, "[#{'!'*@pet.sick}SICK#{'!'*@pet.sick}]") if @pet.sick > 0
      render_at(left+1, top+1, status_bar)
      render_at(left+9, top+4, @pet.display)
      render_at(left+1, top+GAME_HEIGHT-3, action_bar)
      @pet.poops.each do |poop|
        render_at(left+1+poop.x, top+1+poop.y, poop.step)
      end
    end

    def status_bar
      "#{"♥"*@pet.health}#{"♡"*(10-@pet.health)}      #{"☺"*(10-@pet.happiness)}#{"☻"*@pet.happiness}"
    end

    def action_bar
      subbar = if @isfeeding
                 "[b]read [s]nack [m]ed"
               elsif @isplaying
                 "[g]uess [d]ice"
               end
      <<~EOBAR
        [p]lay   [f]eed  [c]lean
        #{subbar}
      EOBAR
    end
  end
end

