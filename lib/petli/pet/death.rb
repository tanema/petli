module Petli
  class Pet
    module Death
      extend Tatty::DB::Attributes
      db_attr :birth, default: Time.now, readonly: true
      db_attr :died_at

      def check_if_dead
        not_happy = self.happiness <= 1
        not_healthy = self.health <= 1
        is_sick = self.sick > 2
        too_much_time = days_since(self.last_meal) >= 1
        self.died_at = Time.now if not_happy && not_healthy && (is_sick || too_much_time)
      end

      def dead?
        !self.died_at.nil?
      end
    end
  end
end
