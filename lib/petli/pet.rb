module Petli
  class Pet
    require 'time'
    include Watch
    extend DB::Attributes

    MOOD_SCALE = [:angry, :annoyed, :normal, :happy, :great]

    db_attr :birth, default: Time.now.to_s, readonly: true
    db_attr :health, default: 5
    db_attr :mood, default: :normal
    db_attr :happiness, default: 5
    db_attr :discipline, default: 5
    db_attr :sick, default: 0
    db_attr :last_play, default: Time.now
    db_attr :last_meal, default: Time.now
    db_attr :poops, default: []

    def initialize
      super()
      @animation = Animator.new(
        hatching: (Time.now - Time.parse(self.birth)) < 10,
        mood: self.mood,
      )
    end

    def reset
      @animation.action = :walk
    end

    def display
      if hours_since(self.last_meal) > 1
        hours_past = hours_since(self.last_meal)
        self.last_meal = Time.now
        (0...hours_past).each do
          self.health = [1, self.health-1].max
          self.poop if rand <= 0.3
        end
      end

      if hours_since(self.last_play) > 3
        self.happiness = [1, self.happiness-1].max
        self.last_play = Time.now
      end

      self.happiness = [self.happiness, 5].min if self.health <= 3
      self.sick = self.poops.filter{|poop| hours_since(poop.hatch) > 1 }.count
      self.mood = MOOD_SCALE[((self.happiness.to_f/10.0)*(MOOD_SCALE.count - 1)).floor ]

      @animation.mood = self.sick > 0 ? :sick : self.mood
      @animation.step
    end

    def feed(food: :bread)
      self.last_meal = Time.now unless food == :medicine
      @animation.eat(food: food) do
        self.health = [10, self.health+1].min unless food == :medicine
        if food == :candy
          self.discipline = [1, self.discipline-0.3].max
          self.happiness = [10, self.happiness+1].min
        end
        self.sick = [0, self.sick - 1].max if food == :medicine
      end
    end

    def win
      self.happiness = [10, self.happiness+1].min
    end

    def lose
      # todo I dont really want it to become more unhappy if they lose
    end

    def play(game: :dice)
      self.last_play = Time.now
      @animation.action = :stand
    end

    def poop
      self.poops << Poop.new(*Poop::LOCATIONS[self.poops.count]) if self.poops.count < Poop::LOCATIONS.count
    end

    def clean
      self.poops = []
    end

    def busy?
      @animation.busy?
    end

    def celebrate
      @animation.celebrate
    end

    def embarass
      @animation.embarass
    end

    def lifetime
      days_since(self.birth).to_i
    end
  end
end
