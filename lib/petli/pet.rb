module Petli
  class Pet
    include Watch
    extend Tatty::DB::Attributes

    MOOD_SCALE = %i(angry annoyed normal happy great)
    POOP_LOCATIONS = [[1,1], [1,4], [1,7], [11,1], [11,7], [20,1], [20,4], [20,7]]

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
      @atlas = avail_animations[:infant].first
      hatch if (Time.now - self.birth) < 10
    end

    def reset
      @doing = nil
    end

    def display
      return animation.next if self.dead?

      if hours_since(self.last_meal) > 1
        hours_past = hours_since(self.last_meal)
        self.last_meal = Time.now
        (0...hours_past).each do |i|
          next if rand <= 0.3
          self.health = [1, self.health-1].max
          self.happiness = [1, self.happiness-1].max
          self.poops << hours_ago(i) if rand <= 0.8 && self.poops.count < POOP_LOCATIONS.count
        end
        self.sick = self.poops.filter{|poop| hours_since(poop) > 1 }.count
      end

      if hours_since(self.last_play) > 1
        hours_past = hours_since(self.last_play)
        self.last_play = Time.now
        (0...hours_past).each do
          next if rand <= 0.3
          self.happiness = [1, self.happiness-1].max
        end
      end

      self.happiness = [self.happiness, 5].min if self.health <= 3
      self.mood = MOOD_SCALE[((self.happiness.to_f/10.0)*(MOOD_SCALE.count - 1)).floor]

      reset if animation.step && !animation.loop
      self.check_if_dead
      animation.display
    end

    def check_if_dead
      not_happy = self.happiness <= 1
      not_healthy = self.health <= 1
      is_sick = self.sick > 2
      too_much_time = days_since(self.last_meal) >= 1
      self.died_at = Time.now if not_happy && not_healthy && (is_sick || too_much_time)
    end

    def feed(food: :bread)
      return self.embarass if ((food == :medicine && self.sick <= 0) || (self.health == 10 && food != :medicine))
      self.last_meal = Time.now unless food == :medicine
      react("eat_#{food}")
      self.feed!(food: food)
    end

    def feed!(food: :bread)
      self.health = [10, self.health+1].min unless food == :medicine
      self.happiness = [10, self.happiness+1].min if food == :candy
      self.sick = [0, self.sick - 1].max if food == :medicine
    end

    def win
      self.happiness = [10, self.happiness+1].min
    end

    def lose
      # todo I dont really want it to become more unhappy if they lose
    end

    def play(game: :dice)
      self.last_play = Time.now
      react(:stand)
    end

    def clean
      self.poops = []
    end

    def busy?
      !@doing.nil?
    end

    def dead?
      !self.died_at.nil?
    end

    def celebrate
      react(:celebrate)
    end

    def embarass
      react(:embarass)
    end

    def hatch
      @doing = avail_animations[:hatch]
    end

    def react(action)
      anim = @atlas[action]
      anim.reset
      @doing = anim
    end

    def lifetime
      (self.died_at.nil? ? days_since(self.birth) : days_since(self.birth, self.died_at)).to_i
    end

    def animation
      if self.dead?
        avail_animations[:death]
      elsif !@doing.nil?
        @doing
      elsif self.sick > 0
        @atlas[:walk_sick]
      else
        @atlas["walk_#{self.mood}"]
      end
    end

    def avail_animations
      @avail_animations ||= {
        hatch: Tatty::Anim.from_atlas('./data/hatch.txtanim'),
        infant: Dir["./data/infant/*.txtanim"].map {|p| Tatty::Atlas.new(p) },
        teen: Dir["./data/teen/*.txtanim"].map {|p| Tatty::Atlas.new(p) },
        adult: Dir["./data/adult/*.txtanim"].map {|p| Tatty::Atlas.new(p) },
        death: Tatty::Anim.from_atlas('./data/death.txtanim'),
      }
    end
  end
end
