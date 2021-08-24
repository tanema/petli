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
        poops.each do |poop|
          ctx.render_at(ox+1+poop.x, oy+1+poop.y, poop.step)
        end
        @pet.poops = poops
        ctx.render_at(ox+9, oy+4, @pet.display)
        ctx.render_at(ox+9, oy+3, "[#{'!'*@pet.sick}SICK#{'!'*@pet.sick}]") if @pet.sick > 0
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
