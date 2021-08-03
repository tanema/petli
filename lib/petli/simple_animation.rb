module Petli
  class SimpleAnimation
    def initialize(frames, x:, y:, framerate: 3)
      @x = x
      @y = y
      @birth = Time.now
      @frame = 0
      @frames = frames
      @rate = framerate
    end

    def step
      @frame += 1
      @frame = 0 if self.frame >= @frames.count
      @frames[self.frame]
    end

    def frame
      (@frame/@rate).ceil
    end
  end
end

