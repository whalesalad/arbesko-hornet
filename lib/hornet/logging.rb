require 'time'
require 'logger'

module Hornet
  class Logging

    class Pretty < Logger::Formatter
      def call(severity, time, program_name, message)
        "#{time.utc.iso8601} #{Process.pid} TID-#{Thread.current.object_id.to_s(36)} #{severity}: #{message}\n"
      end
    end

    def self.init_logger(log_target = STDOUT)
      @logger = Logger.new(log_target)
      @logger.level = Logger::INFO
      @logger.formatter = Pretty.new
      @logger
    end

    def self.logger
      @logger || init_logger
    end

    def self.logger=(log)
      @logger = (log ? log : Logger.new('/dev/null'))
    end

    def logger
      Hornet::Logging.logger
    end

  end
end