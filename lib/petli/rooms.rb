module Petli
  module Rooms
    class Room
      attr_reader :pet

      def initialize(pet)
        @pet = pet
      end

      def enter
      end

      def goto(room_name)
        klass = ::Petli.const_get("Rooms::#{room_name.capitalize}")
        self.leave unless klass.nil?
        ::Petli::Rooms.goto(klass)
      end

      def leave
      end

      def actions
        %w()
      end

      def action_bar
        return "" if @pet.dead?
        self.actions.map {|a| "[#{a[0]}]#{a[1..]}"}.join(" ")
      end

      def keypress(event)
      end

      def draw(ctx, ox, oy)
        poops = @pet.poops
        poops.each_with_index do |poop, i|
          x, y = Poop::LOCATIONS[i]
          ctx.render_at(ox+1+x, oy+1+y, poop.step)
        end
        @pet.poops = poops
        ctx.render_at(ox+9, oy+4, @pet.display)
        sick = @pet.sick
        if sick > 0 && !@pet.dead?
          ctx.render_at(ox+11-sick, oy+4, "[#{'!'*sick}SICK#{'!'*sick}]")
        end
      end
    end

    autoload :Main, "petli/rooms/main"
    autoload :Feed, "petli/rooms/feed"
    autoload :Play, "petli/rooms/play"
    autoload :Guess, "petli/rooms/guess"
    autoload :Dice, "petli/rooms/dice"

    def self.current
      @room
    end

    def self.enter(pet)
      @pet = pet
      goto(Main)
    end

    def self.goto(klass)
      @room = klass.new(@pet)
      @room.enter
    end
  end
end
