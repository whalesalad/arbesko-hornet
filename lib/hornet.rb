libdir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'subexec'

require 'hornet/version'
require 'hornet/filesize'
require 'hornet/image_manager'
# require 'hornet/image_manipulator'

module Hornet
  NAME = "Hornet"
  
  ALLOWED_TYPES = %w{single double}
  ALLOWED_SLUGS = %w{small medium large pdf mask}
  ALLOWED_EXTS = %w{jpg png}

  BASE_DIR = File.expand_path(File.join(File.dirname(__FILE__), '../'))
  TMP_DIR = File.join(BASE_DIR, 'tmp')
  OUTPUT_DIR = File.join(BASE_DIR, 'public')
end