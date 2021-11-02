module Petli
  class Pet
    module Food
      extend Tatty::DB::Attributes

      POOP_LOCATIONS = [[1,1], [1,4], [1,7], [11,1], [11,7], [20,1], [20,4], [20,7]]

      db_attr :health, default: 5
      db_attr :last_meal, default: Time.now
      db_attr :sick, default: 0
      db_attr :poops, default: []

      def update_hunger
        for_hours_since(last_meal) do |i, hr_ago|
          self.last_meal = Time.now
          next if rand <= 0.3
          self.health = [1, self.health-1].max
          self.happiness = [1, self.happiness-1].max
          self.poops << hr_ago if rand <= 0.8 && self.poops.count < POOP_LOCATIONS.count
          self.sick = self.poops.filter{|poop| hours_since(poop) > 1 }.count
        end
      end

      def feed(food: :bread)
        return self.embarass if ((food == :medicine && self.sick <= 0) || (self.health == 10 && food != :medicine))
        self.last_meal = Time.now unless food == :medicine
        react("eat_#{food}")
        self.feed!(food: food)
      end

      def feed!(food: :bread)
        self.health = [10, self.health+2].min unless food == :medicine
        self.happiness = [10, self.happiness+2].min if food == :candy
        self.sick = [0, self.sick - 1].max if food == :medicine
      end

      def clean
        self.poops = []
      end
    end
  end
end
