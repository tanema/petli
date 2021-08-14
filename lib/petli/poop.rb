module Petli
  class Poop < SimpleAnimation
    LOCATIONS = [[1,1], [1,4], [1,7], [11,1], [11,7], [20,1], [20,4], [20,7]]

    attr_reader :hatch

    ANIMATION = ["ı ı ı\n༼ᵔ◡ᵔ༽", "ϟ ϟ ϟ\n༼ಠ益ಠ༽"]
    def initialize(x, y)
      super(ANIMATION, x: x, y: y)
      @hatch = Time.now
    end
  end
end
