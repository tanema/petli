module Petli
  class Poop
    include Watch

    LOCATIONS = [[1,1], [1,4], [1,7], [11,1], [11,7], [20,1], [20,4], [20,7]]
    ANIMATION = ["ı ı ı\n༼ᵔ◡ᵔ༽", "ϟ ϟ ϟ\n༼ಠ益ಠ༽"]

    attr_accessor :hatch

    def initialize(hrsago)
      @frame = 0
      self.hatch = hours_ago(hrsago)
    end

    def step
      @frame += 1
      anim_fram = (@frame/2).ceil
      @frame = 0 if anim_fram >= ANIMATION.count
      ANIMATION[anim_fram]
    end

    def to_json(opts)
      self.hatch.to_json
    end
  end
end
