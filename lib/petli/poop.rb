module Petli
  class Poop < Tatty::Anim
    LOCATIONS = [[1,1], [1,4], [1,7], [11,1], [11,7], [20,1], [20,4], [20,7]]
    ANIMATION = ["ı ı ı\n༼ᵔ◡ᵔ༽", "ϟ ϟ ϟ\n༼ಠ益ಠ༽"]
    def initialize()
      super(ANIMATION)
    end
  end
end
