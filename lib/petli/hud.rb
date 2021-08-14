require_relative '../tatty/game'

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
      exit if event.value == "q"
      return if @pet.busy?
      Rooms.current.keypress(event)
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
      Rooms.current.draw(self, left, top)
      render_at(left+1, top+1, status_bar)
      render_at(left+1, top+GAME_HEIGHT-2, Rooms.current.action_bar)
    end

    def status_bar
      "#{"♥"*@pet.health}#{"♡"*(10-@pet.health)}      #{"☺"*(10-@pet.happiness)}#{"☻"*@pet.happiness}"
    end
  end
end
