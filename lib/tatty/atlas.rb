require 'yaml'

module Tatty
  class Atlas
    def initialize(filepath)
      @filepath = File.expand_path(filepath)
      @sheet = {}
      parse_data
    end

    def [](name)
      @sheet[name.to_sym]
    end

    private

    def parse_data
      chunks = File.read(@filepath).split(/^---.*$/)
      shouldBeYaml = true
      default_config = {name: :default}.merge(parse_yaml(chunks.first))
      config = {}
      chunks.each do |chunk|
        if shouldBeYaml
          config = default_config.merge(parse_yaml(chunk))
        else
          validate_config(config)
          @sheet[config[:name].to_sym] = Anim.new(parse_animation(chunk, config), **config)
        end
        shouldBeYaml = !shouldBeYaml
      end
    end

    def validate_config(config)
      name = config[:name].to_sym
      if name.nil?
        raise "All animations in an atlas need to have a name attribute"
      elsif !@sheet[name].nil?
        raise "Duplicate animation name '#{name}'"
      elsif config[:width].nil? || config[:height].nil?
        raise "Animation '#{name}' does not have a width and/or height attribute"
      end
    end

    def parse_yaml(chunk)
      YAML.load(chunk).each_with_object({}) { |(k,v), h| h[k.to_sym] = v }
    end

    def parse_animation(chunk, config)
      width, height = config[:width], config[:height]
      frames = []
      frame_offset = 0
      chunk.lines.each_slice(height+1).to_a.each do |frame_line|
        frame_line.each do |line|
          i = 0
          while line.length > 1
            frames[frame_offset+i] ||= []
            frames[frame_offset+i] << line.slice!(0, width)
            line.slice!(0, 1) # separator
            i+=1
          end
        end
        frame_offset = frames.count
      end
      frames.map {|f| f.join("\n") }
    end
  end
end

