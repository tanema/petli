module Tatty
  require 'tty-cursor'
  require 'tty-screen'
  require 'tty-box'

  class Stage
    attr_accessor :framerate

    def initialize
      @cursor = TTY::Cursor
      @framerate = 0.1
      @buffer = ""
    end

    def leave
    end

    def goto(klass, **kargs)
      ::Tatty.goto(klass, **kargs)
    end

    def keypress(evt)
    end

    def screen_size
      TTY::Screen.size
    end

    def screen_width
      TTY::Screen.width
    end

    def screen_height
      TTY::Screen.height
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

    def draw
      render "not implemented"
    end

    def step
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

    def render_box(*content, **kwargs, &block)
      render @cursor.save
      move_to(0, 0)
      render TTY::Box.frame(*content, **kwargs, &block)
      render @cursor.restore
    end
  end
end
