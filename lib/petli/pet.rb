module Petli
  class Pet
    autoload :Food, "petli/pet/food"
    autoload :Happy, "petli/pet/happy"
    autoload :Death, "petli/pet/death"
    autoload :Animation, "petli/pet/animation"

    extend Tatty::DB::Attributes
    include Animation
    include Death
    include Food
    include Happy
    include Watch

    def initialize
      super()
      setup_animation
    end

    def display
      return animation.next if self.dead?
      update_hunger
      update_happiness
      check_if_dead
      update_animation
      animation.display
    end

    def lifetime
      (self.died_at.nil? ? days_since(self.birth) : days_since(self.birth, self.died_at)).to_i
    end
  end
end
