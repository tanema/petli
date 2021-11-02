module Petli
  class Pet
    module Animation
      extend Tatty::DB::Attributes
      db_attr :phase, default: :infant
      db_attr :phase_select, default: 0
      db_attr :lights_out, default: false

      def setup_animation
        hatch if (Time.now - self.birth) < 10
      end

      def update_animation
        reset if animation.step && !animation.loop
        if phase == :infant && hours_since(birth) > 1
          self.phase = :teen
          self.phase_select = rand(0...avail_animations[phase].count)
        elsif phase == :teen && days_since(birth) > 1
          self.phase = :adult
          self.phase_select = rand(0...avail_animations[phase].count)
        end
      end

      def reset
        @doing = nil
      end

      def busy?
        !@doing.nil?
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

      def light_switch
        self.lights_out = !lights_out
        self.happiness = [1, self.happiness-1].max if self.lights_out && !sleeping?
      end

      def sleeping?
        hour = Time.now.hour
        hour >= 16 || hour <= 8
      end

      def react(action)
        anim = atlas[action]
        anim.reset
        @doing = anim
      end

      def animation
        if self.dead?
          avail_animations[:death]
        elsif !@doing.nil?
          @doing
        elsif self.lights_out
          if sleeping?
            avail_animations[:sleep][:sleep]
          else
            avail_animations[:sleep][:blink]
          end
        elsif self.sick > 0
          atlas[:walk_sick]
        else
          atlas["walk_#{self.mood}"]
        end
      end

      def atlas
        avail_animations[phase][phase_select]
      end

      def avail_animations
        @avail_animations ||= {
          hatch: Tatty::Anim.from_atlas(Petli.data_path('hatch.txtanim')),
          infant: Dir[Petli.data_path('infant',"*.txtanim")].map {|p| Tatty::Atlas.new(p) },
          teen: Dir[Petli.data_path('teen',"*.txtanim")].map {|p| Tatty::Atlas.new(p) },
          adult: Dir[Petli.data_path('adult',"*.txtanim")].map {|p| Tatty::Atlas.new(p) },
          death: Tatty::Anim.from_atlas(Petli.data_path('death.txtanim')),
          sleep: Tatty::Atlas.new(Petli.data_path('sleep.txtanim')),
        }
      end
    end
  end
end
