module Tatty
  require "pstore"
  require "forwardable"
  require "tty-platform"
  require 'fileutils'

  class DB
    module Attributes
      def db_attr(name, default: nil, readonly: false)
        name = name.to_sym
        define_method(name) { DB.get(name, default) }
        define_method("#{name}=".to_sym) { |val| DB.set(name => val) } unless readonly
      end
    end

    extend SingleForwardable
    def_delegators :new, :keys, :exists?, :set, :get, :del, :clear, :dump

    attr_reader :db

    def initialize
      config_path = if !$tattydboverridepath.nil?
          $tattydboverridepath
        elsif TTY::Platform.windows?
          File.join(ENV["APPDATA"], 'petli', 'data.pet')
        elsif TTY::Platform.linux?
          File.join(ENV["XDG_CONFIG_DIRS"] || '/etc/xdg', 'petli', 'data.pet')
        elsif TTY::Platform.mac?
          File.join(File.expand_path('~/Library/Application Support'), 'petli', 'data.pet')
        end
      FileUtils.mkdir_p(File.dirname(config_path))
      @db = PStore.new(config_path)
    end

    def keys
      db.transaction(true) { db.roots }
    end

    def exists?(key)
      db.transaction(true) { db.root?(key) }
    end

    def set(**args)
      db.transaction do
        args.each {|key, val| val.nil? ? db.delete(key) : db[key] = val}
      end
    end

    def get(key, default=nil)
      val = db.transaction(true) { db[key] }
      if val.nil?
        val = default unless default.nil?
        val = yield if block_given?
        db.transaction { db[key] = val }
      end
      val
    end

    def del(*args)
      db.transaction { args.each { |key| db.delete(key) } }
    end

    def clear
      del(*keys)
    end

    def dump
      require 'json'
      begin
        file = File.new(@db.path, mode: IO::RDONLY | IO::BINARY, encoding: Encoding::ASCII_8BIT)
        JSON.dump(Marshal::load(file.read))
      ensure
        file.close
      end
    end
  end
end
