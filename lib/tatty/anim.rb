module Tatty
  class Anim
    def initialize(atlas, frame: 0, rate: 2)
      @atlas = atlas
      @frame = frame
      @rate = rate
    end

    def step
      @frame += 1
      @frame = 0 if self.frame >= @atlas.count
      @atlas[self.frame]
    end

    def frame
      (@frame/@rate).ceil
    end
  end
end
