module Petli
  class Poop
    include Watch

    LOCATIONS = [[1,1], [1,4], [1,7], [11,1], [11,7], [20,1], [20,4], [20,7]]
    ANIMATION = ["ı ı ı\n༼ᵔ◡ᵔ༽", "ϟ ϟ ϟ\n༼ಠ益ಠ༽"]

    attr_accessor :hatch, :x, :y

    def initialize(hrsago, x, y)
      @frame = 0
      @rate = 2
      self.x = x
      self.y = y
      self.hatch = hours_ago(hrsago)
    end

    def step
      @frame += 1
      @frame = 0 if self.frame >= ANIMATION.count
      ANIMATION[self.frame]
    end

    def frame
      (@frame/@rate).ceil
    end
  end
end
