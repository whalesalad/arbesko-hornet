libdir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'subexec'
require 'listen'

require 'hornet/version'
require 'hornet/logging'
require 'hornet/hive'
require 'hornet/listener'
require 'hornet/filesize'
require 'hornet/image_processor'

module Hornet
  NAME = "Hornet"
  
  ALLOWED_SLUGS = %w{small medium large pdf}
  ALLOWED_EXTS = %w{jpg png}

  IMAGE_SIZES = {
    small: 150,
    medium: 250,
    large: 700,
    pdf: 1000
  }

  BASE_DIR = File.expand_path(File.join(File.dirname(__FILE__), '../'))
  TMP_DIR = File.join(BASE_DIR, 'tmp')
  OUTPUT_DIR = File.join(BASE_DIR, 'public')

  def self.start(options)
    hive = Hornet::Hive.new(options)
    hive.start
    return hive
  end

  def self.logger
    Hornet::Logging.logger
  end

end