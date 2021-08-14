module Tatty
  require 'tty-cursor'
  require 'tty-config'
  require 'tty-screen'
  require 'tty-reader'
  require 'tty-box'

  class Game
    attr_accessor :framerate, :config

    def initialize
      @config = TTY::Config.new
      @cursor = TTY::Cursor
      @reader = TTY::Reader.new
      @framerate = 0.1
      @buffer = ""

      @reader.on(:keypress) do |event|
        self.keypress(event)
      end
    end

    def screen_size
      TTY::Screen.size
    end

    def move_to(x, y)
      render @cursor.move_to(x, y)
    end

    def render(out)
      @buffer += out
    end

    def render_at(x, y, out)
      out.to_s.each_line do |line|
        render @cursor.move_to(x, y)
        render line
        y += 1
      end
    end

    def keypress(event)
    end

    def draw
      render "not implemented"
    end

    def run
      begin
        @cursor.invisible do
          while true
            @reader.read_keypress(nonblock: true)
            last_buffer = @buffer
            @buffer = ""
            render @cursor.clear_screen
            move_to(0, 0)
            self.draw
            if last_buffer != @buffer
              print @buffer
            end
            sleep(@framerate)
          end
        end
      rescue Interrupt => e
      ensure
        print @cursor.clear_screen
        print @cursor.move_to(0, 0)
      end
    end

    def render_box(*content, **kwargs, &block)
      render @cursor.save
      move_to(0, 0)
      render TTY::Box.frame(*content, **kwargs, &block)
      render @cursor.restore
    end
  end
end
