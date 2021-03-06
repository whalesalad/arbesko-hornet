# new Hornet::Listener(:single => PATH, :double => PATH).start
# init with single and double directories
# regenerate! to force regeneration of all

module Hornet
  class Listener
    attr_accessor :path, :listener

    def initialize(path)
      @path = path

      callback = Proc.new do |modified, added, removed|
        (modified + added).each do |f|
          Hornet.logger.info "Listener notified of #{f}"
          process_file(f)
        end
      end

      @listener = Listen.to(@path, &callback)
    end

    def start
      @listener.start
    end

    def process_all
      Dir.glob(@path + '/*.png').each do |file|
        process_file(file)
      end
    end

    def process_file(file)
      Hornet.logger.info "Processing #{file}."
      ImageProcessor.new(file).process!
    end

  end
end