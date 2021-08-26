module Petli
  require "pstore"
  require "forwardable"

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

    def initialize(path: "petli.pet")
      @db = PStore.new(path)
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
      val = db.transaction(true) { db.fetch(key, default) }
      val = db.transaction { db[key] = yield } if val.nil? && block_given?
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

