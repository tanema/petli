module Petli
  DAYS_DIV = 86400
  HOURS_DIV = 3600
  MINS_DIV = 60

  module Watch
    require 'time'
    private

    def days_since(last, now=Time.now)
      time_elapsed(last, DAYS_DIV, now)
    end

    def hours_since(last)
      time_elapsed(last, HOURS_DIV)
    end

    def hours_ago(hrs)
      Time.now - (hrs * 3600)
    end

    def mins_since(last)
      time_elapsed(last, MINS_DIV)
    end

    def time_elapsed(last, div, now=Time.now)
      ((now - Time.parse(last.to_s)) / div)
    end
  end
end
