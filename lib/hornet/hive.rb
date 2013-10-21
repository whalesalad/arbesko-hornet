module Hornet
  class Hive

    def initialize(options)
      @options = options
      @listener = Listener.new(options[:directory])
    end

    def start
      @listener.start
    end

    def force!
      @listener.process_all
    end

  end
end