module Petli
  class Pet
    include Watch
    extend DB::Attributes

    MOOD_SCALE = [:angry, :annoyed, :normal, :happy, :great]

    db_attr :birth, default: Time.now, readonly: true
    db_attr :health, default: 5
    db_attr :mood, default: :normal
    db_attr :happiness, default: 5
    db_attr :sick, default: 0
    db_attr :died_at
    db_attr :last_play, default: Time.now
    db_attr :last_meal, default: Time.now
    db_attr :poops, default: []

    def initialize
      super()
      @animation = Animator.new(
        hatching: (Time.now - self.birth) < 10,
        mood: self.mood,
        action: self.died_at.nil? ? :walk : :death
      )
    end

    def reset
      @animation.action = :walk
    end

    def display
      return @animation.step if self.dead?

      if hours_since(self.last_meal) > 1
        hours_past = hours_since(self.last_meal)
        self.last_meal = Time.now
        (0...hours_past).each do |i|
          self.health = [1, self.health-1].max
          self.happiness = [1, self.happiness-1].max
          self.poop(hours_past - i) if rand <= 0.8
        end
        self.sick = self.poops.filter{|poop| hours_since(poop.hatch) > 1 }.count
      end

      if hours_since(self.last_play) > 1
        hours_past = hours_since(self.last_play)
        self.last_play = Time.now
        (0...hours_past).each do
          self.happiness = [1, self.happiness-1].max
        end
      end

      self.happiness = [self.happiness, 5].min if self.health <= 3
      self.mood = MOOD_SCALE[((self.happiness.to_f/10.0)*(MOOD_SCALE.count - 1)).floor ]

      self.check_if_dead

      @animation.mood = self.sick > 0 ? :sick : self.mood
      @animation.step
    end

    def check_if_dead
      not_happy = self.happiness <= 1
      not_healthy = self.health <= 1
      is_sick = self.sick > 2
      too_much_time = days_since(self.last_meal) >= 1

      if not_happy && not_healthy && (is_sick || too_much_time)
        self.died_at = Time.now
        @animation.action = :death
      end
    end

    def feed(food: :bread)
      return self.embarass if ((food == :medicine && self.sick <= 0) || (self.health == 10 && food != :medicine))
      self.last_meal = Time.now unless food == :medicine
      @animation.eat(food: food) do
        self.health = [10, self.health+1].min unless food == :medicine
        self.happiness = [10, self.happiness+1].min if food == :candy
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

    def poop(hours_ago)
      self.poops = self.poops + [Poop.new(hours_ago, *Poop::LOCATIONS[self.poops.count])] if self.poops.count < Poop::LOCATIONS.count
    end

    def clean
      self.poops = []
    end

    def busy?
      @animation.busy?
    end

    def dead?
      @animation.action == :death
    end

    def celebrate
      @animation.celebrate
    end

    def embarass
      @animation.embarass
    end

    def lifetime
      if self.died_at.nil?
        days_since(self.birth).to_i
      else
        days_since(self.birth, self.died_at).to_i
      end
    end
  end
end
