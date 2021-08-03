module Petli
  require 'time'
  require_relative './animator'
  require_relative './db'
  require_relative './watch'
  require_relative './simple_animation'

  POOPLOCS = [[1,1], [1,4], [1,7], [11,1], [11,7], [20,1], [20,4], [20,7]]
  class Poop < SimpleAnimation
    attr_reader :hatch

    ANIMATION = ["ı ı ı\n༼ᵔ◡ᵔ༽", "ϟ ϟ ϟ\n༼ಠ益ಠ༽"]
    def initialize(x, y)
      super(ANIMATION, x: x, y: y)
      @hatch = Time.now
    end
  end

  class Pet
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
      #sick
      # longer poop exists, more skulls, less happ(faster)
      # poop happens after eating (faster unhappy)
      # hungry (faster unhappy)
      # food, snack, play more happy
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
        self.happiness -= 1
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
          self.happiness += [10, self.happiness+1].min
        end
        self.sick = [0, self.sick - 1].max if food == :medicine
      end
    end

    def play(food: :dice)
      self.last_play = Time.now
    end

    def poop
      self.poops << Poop.new(*POOPLOCS[@poops.count]) if @poops.count < POOPLOCS.count
    end

    def clean
      self.poops = []
    end

    def busy?
      @animation.busy?
    end

    def lifetime
      days_since(self.birth).to_i
    end
  end
end

