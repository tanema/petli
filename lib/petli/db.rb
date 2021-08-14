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
    def_delegators :new, :keys, :exists?, :set, :get, :del, :clear

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
  end
end

