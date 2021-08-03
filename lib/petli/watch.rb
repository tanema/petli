module Petli
  DAYS_DIV = 86400
  HOURS_DIV = 3600
  MINS_DIV = 60

  module Watch
    private

    def days_since(last)
      time_elapsed(last, DAYS_DIV)
    end

    def hours_since(last)
      time_elapsed(last, HOURS_DIV)
    end

    def mins_since(last)
      time_elapsed(last, MINS_DIV)
    end

    def time_elapsed(last, div)
      ((Time.now - Time.parse(last.to_s)) / div)
    end
  end
end
