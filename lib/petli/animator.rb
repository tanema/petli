module Petli
  require 'json'

  class Animator
    ANIMATIONS = {
      egg: ["   _\n  / \\\n  \\_/", "   _\n((/ \\\n  \\_/))", "   _\n  / \\))\n((\\_/"]*5,
      egg_crack: [" _\n/ \\\n\\_‚/"," _\n/ \\\n\\_¡/"," _\n/ \\\n\\_¦/"," _\n/ ¡\\\n\\_ϟ/"," _\n/ ¦\\\n\\_ϟ/"," _\n/ ϟ\\\n\\_ϟ/","\n/ ϟ\\\n\\_ϟ/"," ☁\n/ ϟ\\\n\\_ϟ/"],
      stand: ["\n\nahe m eha\n", "\n\nahe m eha\n"],
      left: ["\n\nahe m e ha\n", "\n\nahe m e ha\n"],
      right: ["\n\nah e m eha\n", "\n\nah e m eha\n"],
      item: ["\n\nahe m eha fff\n", "\n\nahe m eha fff\n", "\n\nahe m eha fff\n", "\n\nahe m eha fff\n"],
      eat: ["\n\nahe m eha fff\n", "\n\nahe m eha  ff\n", "\n\nahe m eha  ff\n", "\n\nahe m eha   f\n", "\n\nahe m eha   f\n", "\n\nahe m eha\n"],
      walk: ["\n\n ahe m eha\n", "\n\nahe m e ha\n", "\n\nahe m eha\n", "\n\nah e m eha\n"],
      hop: ["\n\n ahe m eha\n", "\nahe m e ha\n\n", "\n\nahe m e ha\n", "\n\nahe m eha\n", "\nah e m eha\n\n", "\n\nah e m eha\n"],
    }

    attr_accessor :mood
    attr_reader :action

    def initialize(hatching:, mood:, action: :walk)
      @frame = 0
      @food = :bread
      @mood = mood
      @action = action
      if hatching
        @mood_stack = [:mezmerized, :mezmerized, :mezmerized, :mezmerized]
        @action_stack = [:egg, :egg_crack, :stand, :stand]
      else
        @mood_stack = []
        @action_stack = []
      end
    end

    def step
      self.add_frame
      leftarm, rightarm = getit(:arms, 2)
      lefteye, righteye = getit(:eyes, 2)
      mouth = getit(:mouth)
      lefthead, righthead = getit(:head, 2)
      [leftarm,lefthead,lefteye,mouth,righteye,righthead,rightarm]

      food_peices = self.food.split('')

      ANIMATIONS[self.action][self.frame]
        .sub('a', leftarm.to_s).sub('a', rightarm.to_s)
        .sub('h', lefthead).sub('h', righthead)
        .sub('e', lefteye).sub('e', righteye)
        .sub('m', mouth)
        .reverse
        .sub('f', food_peices[2]).sub('f', food_peices[1]).sub('f', food_peices[0])
        .reverse
    end

    def eat(food: :bread, &block)
      @busy = true
      @frame = 0
      @food = food
      @action_stack = [:item, :eat, :stand, :stand, :stand, :stand]
      @mood_stack = [:mezmerized, :eating, :eating, :mezmerized, :mezmerized]
      @on_complete = block
    end

    def celebrate
      @action_stack = [:stand, :stand, :stand, :stand]
      @mood_stack = [:mezmerized, :mezmerized, :mezmerized, :mezmerized]
    end

    def embarass
      @action_stack = [:stand, :stand, :stand, :stand]
      @mood_stack = [:embarassed, :embarassed, :embarassed, :embarassed]
    end

    def busy?
      @busy
    end

    def action=(act)
      @action = act
      @frame = 0
    end

    private

    def add_frame
      frame_count = ANIMATIONS[self.action].count
      @frame += 1
      if self.frame == frame_count
        @frame = 0
        @action_stack.shift if @action_stack.count > 0
        @mood_stack.shift if @mood_stack.count > 0
        if @action_stack.count == 0 && @mood_stack.count == 0
          @busy = false
          @on_complete.call unless @on_complete.nil?
          @on_complete = nil
        end
      end
    end

    def food
      self.data[@food]
    end

    def frame # to control framerate
      (@frame/3).ceil
    end

    def action
      @action_stack.count > 0 ? @action_stack[0] : @action
    end

    def mood
      @mood_stack.count > 0 ? @mood_stack[0] : @mood
    end

    def getit(part, vals=1)
      mood_part = self.data[part][self.mood] || self.data[part][:default]
      part_frame = self.frame % mood_part.count
      result = mood_part[part_frame]
      if vals == 2 && result.is_a?(String)
        [result, result]
      else
        result
      end
    end

    def data
      @data ||= JSON.parse(
        File.read(File.expand_path('../../data/character.json', __dir__)),
        {:symbolize_names => true}
      )
    end
  end
end

