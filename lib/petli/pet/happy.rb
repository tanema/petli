module Petli
  class Pet
    module Happy
      extend Tatty::DB::Attributes
      MOOD_SCALE = %i(angry annoyed normal happy great)

      db_attr :mood, default: :normal
      db_attr :last_play, default: Time.now
      db_attr :happiness, default: 5

      def update_happiness
        for_hours_since(last_play) do |i|
          self.last_play = Time.now
          next if rand <= 0.3
          self.happiness = [[1, self.happiness-1].max, self.health <= 3 ? 5 : 10].min
        end
        self.mood = MOOD_SCALE[((self.happiness.to_f/10.0)*(MOOD_SCALE.count - 1)).floor]
      end

      def play(game: :dice)
        self.last_play = Time.now
        react(:stand)
      end

      def win
        self.happiness = [10, self.happiness+1].min
      end

      def lose
        # todo I dont really want it to become more unhappy if they lose
      end
    end
  end
end
