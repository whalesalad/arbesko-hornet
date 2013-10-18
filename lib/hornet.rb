libdir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'subexec'
require 'listen'

require 'hornet/version'
require 'hornet/filesize'
require 'hornet/image_processor'

module Hornet
  NAME = "Hornet"
  
  ALLOWED_TYPES = %w{single double}
  ALLOWED_SLUGS = %w{small medium large pdf mask}
  ALLOWED_EXTS = %w{jpg png}

  IMAGE_SIZES = {
    small: 150,
    medium: 250,
    large: 700,
    pdf: 900,
    mask: 900
  }

  BASE_DIR = File.expand_path(File.join(File.dirname(__FILE__), '../'))
  TMP_DIR = File.join(BASE_DIR, 'tmp')
  OUTPUT_DIR = File.join(BASE_DIR, 'public')
  # WATCH_DIR = ENV['HORNET_WATCH_DIR'] || ''

  def self.process_directory(type, directory)
    Dir.glob(directory + '/*.png').each do |file|
      process_file(type, file)
    end
  end

  def self.process_file(type, file)
    # /Users/michael/Sites/arbesko/helpar_doublepair__tryck_print/
    ImageProcessor.new(type, file).process!
  end
end