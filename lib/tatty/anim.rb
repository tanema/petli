module Tatty
  class Anim
    attr_reader :width, :height, :loop, :rate, :name

    def self.from_atlas(filepath, name: :default)
      Atlas.new(filepath)[name]
    end

    def initialize(atlas, width:, height:, **kargs)
      @atlas = atlas
      @rate = kargs[:speed] || 2
      @loop = kargs[:loop] || false
      if kargs[:loop_for].nil?
        @loop_for = -1
      else
        @loop = false
        @loop_for_start = kargs[:loop_for] || -1
        @loop_for = @loop_for_start
      end
      @name = kargs[:name]
      @width = width
      @height = height
      reset
    end

    def reset
      @frame = 0
      @loop_for = @loop_for_start if @loop_for == 0
    end

    def step
      @frame += 1
      if rate_frame >= @atlas.count
        reset if self.loop
        @loop_for -= 1 if @loop_for > 0
        true
      else
        false
      end
    end

    def display
      @atlas[rate_frame]
    end

    def next
      step
      display
    end

    def loop
      @loop || @loop_for > 0
    end

    private

    def rate_frame
      (@frame/@rate).ceil
    end
  end
end
