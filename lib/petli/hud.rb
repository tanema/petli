require 'pastel'

module Petli
  class HUD < Tatty::Game
    GAME_WIDTH = 28
    GAME_HEIGHT = 13

    def initialize
      super()
      @pet = Pet.new
      Rooms.enter(@pet)
    end

    def keypress(event)
      exit if event.value == "q" || event.value == "\e" || event.value == "x"
      return if @pet.busy? || @pet.dead?
      Rooms.current.keypress(event)
    end

    def draw
      h, w = self.screen_size
      left, top = ((w-GAME_WIDTH)/2).round, ((h-GAME_HEIGHT)/2).round
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
      Rooms.current.draw(self, left, top)
      render_at(left+1, top+1, status_bar)
      render_at(left+1, top+GAME_HEIGHT-2, Rooms.current.action_bar)
      render_at(left+GAME_WIDTH-2, top, p.bright_white.bold("[x]"))
    end

    def status_bar
      p = Pastel.new
      "#{p.red("♥")*@pet.health}#{"♡"*(10-@pet.health)}      #{"☺"*(10-@pet.happiness)}#{p.green("☻")*@pet.happiness}"
    end
  end
end
