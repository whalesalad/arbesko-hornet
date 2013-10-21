module Hornet
  class Hive

    def initialize(options)
      @options = options
        
      @listeners = options.select { |k,v| [:single, :double].include?(k) }.map do |type, path|
        Listener.new(type, path)
      end
    end

    def start
      @listeners.each { |l| l.start }
    end

    def force!
      @listeners.each { |l| l.process_all }
    end

  end
end