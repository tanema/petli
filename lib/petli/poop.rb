module Petli
  class Poop < SimpleAnimation
    include Watch

    LOCATIONS = [[1,1], [1,4], [1,7], [11,1], [11,7], [20,1], [20,4], [20,7]]
    ANIMATION = ["ı ı ı\n༼ᵔ◡ᵔ༽", "ϟ ϟ ϟ\n༼ಠ益ಠ༽"]

    attr_accessor :hatch

    def initialize(hrsago, x, y)
      super(ANIMATION, x: x, y: y)
      self.hatch = hours_ago(hrsago)
    end
  end
end
