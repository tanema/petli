require 'pastel'

module Petli
  module Stages
    class Base < Tatty::Stage
      GAME_WIDTH = 28
      GAME_HEIGHT = 13

      def initialize(pet:)
        super()
        @pet = pet
        @poop = Tatty::Anim.from_atlas(Petli.data_path('poop.txtanim'))
        @page = 0
      end

      def keypress(event)
        exit if event.value == "q" || event.value == "\e" || event.value == "x"
        return if @pet.busy? || @pet.dead?
        @page -= 1 if event.key.name == :left && @page > 0
        @page += 1 if event.key.name == :right && @page < action_pages.count - 1
        onkey(event)
      end

      def actions
        %w()
      end

      def action_pages
        pages = []
        current_page = []
        fmt_actions = self.actions.map{|a| "[#{a[0].capitalize}]#{a[1..]}"}
        fmt_actions.each do |action|
          len = (current_page + [action]).join(" ").length
          if len >= GAME_WIDTH-2
            pages << [current_page, current_page.join(" ").length]
            current_page = [action]
          else
            current_page << action
          end
        end
        pages + [[current_page, current_page.join(" ").length]]
      end

      def action_bar
        return "" if @pet.dead? || @pet.busy?
        pages = action_pages
        p = Pastel.new
        page, page_len = pages[@page]
        bar = p.bold(@page > 0 ? "◀" : "◁")
        bar += page.map {|a| "#{p.bold(a[0..2])}#{a[3..]}"}.join(" ")
        bar += (' ' * (GAME_WIDTH-page_len-4))
        bar += p.bold(pages.count > 1 && @page < pages.count - 1 ? "▶" : "▷")
        bar
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

        render_at(left+1, top+1, "#{p.red("♥")*@pet.health}#{"♡"*(10-@pet.health)}  #{@pet.sick > 0 ? p.red("☠") : "☠"}#{@pet.lights_out ? "☼" : p.yellow("☀")}  #{"☺"*(10-@pet.happiness)}#{p.green("☻")*@pet.happiness}")
        render_at(left+1, top+GAME_HEIGHT-2, self.action_bar)
        render_at(left+GAME_WIDTH-2, top, p.bright_white.bold("[x]"))
      end
    end
  end
end
