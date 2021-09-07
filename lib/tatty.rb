module Tatty
  require 'tty-reader'
  require 'tty-cursor'

  autoload :Anim, "tatty/anim"
  autoload :DB, "tatty/db"
  autoload :Stage, "tatty/stage"

  def self.run(klass, **kargs)
    self.goto(klass, **kargs)
    @reader = TTY::Reader.new
    @reader.on(:keypress) do |event|
      self.stage.keypress(event)
    end

    begin
      TTY::Cursor.invisible do
        while true
          @reader.read_keypress(nonblock: true)
          @stage.step
        end
      end
    rescue Interrupt => e
    ensure
      print TTY::Cursor.clear_screen
      print TTY::Cursor.move_to(0, 0)
    end
  end

  def self.stage
    @stage
  end

  def self.goto(klass, **kargs)
    @stage.leave unless @stage.nil?
    @stage = klass.new(**kargs)
  end
end
