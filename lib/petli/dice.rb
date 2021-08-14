module Petli
  class Dice
    Symbols = %w(⚀ ⚁ ⚂ ⚃ ⚄ ⚅)

    def self.roll
      num = (0..5).to_a.sample
      [num + 1, Symbols[num]]
    end
  end
end
