module Tatty
  class Anim
    attr_reader :width, :height, :loop, :rate, :name

    def self.from_atlas(filepath, name: :default)
      Atlas.new(filepath)[name]
    end

    def initialize(atlas, **kargs)
      @atlas = atlas
      @rate = kargs[:speed] || 2
      @loop = kargs[:loop] || false
      @name = kargs[:name]
      @width = kargs[:width]
      @height = kargs[:height]
      reset
    end

    def reset
      @frame = 0
    end

    def step
      @frame += 1
      if rate_frame >= @atlas.count
        reset if @loop
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

    private

    def rate_frame
      (@frame/@rate).ceil
    end
  end
end
