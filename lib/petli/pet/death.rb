module Petli
  class Pet
    module Death
      extend Tatty::DB::Attributes
      db_attr :birth, default: Time.now, readonly: true
      db_attr :died_at

      def check_if_dead
        die! if unhappy? && unhealthy? && (too_sick? || too_hungry?)
      end

      def die!
        self.died_at = Time.now
      end

      def sick?
        self.sick > 0
      end

      def too_sick?
        self.sick > 2
      end

      def too_hungry?
        days_since(self.last_meal) >= 1
      end

      def unhappy?
        self.happiness <= 1
      end

      def unhealthy?
        self.health <= 1
      end

      def dead?
        !self.died_at.nil?
      end

      def lifetime
        (self.died_at.nil? ? days_since(self.birth) : days_since(self.birth, self.died_at)).to_i
      end
    end
  end
end
