module Hornet
  FILESIZE_UNITS = %W(B KB MB GB TB).freeze

  class Filesize
    attr_reader :file_path

    def initialize(file_path)
      @file_path = file_path
    end

    def file_size
      @file_size ||= calculate_file_size(File.size(file_path))
    end

    def calculate_file_size(number)
      if number.to_i < 1024
        exponent = 0
      else
        max_exp = FILESIZE_UNITS.size - 1
        exponent = (Math.log(number) / Math.log(1024)).to_i # convert to base
        exponent = max_exp if exponent > max_exp # we need this to avoid overflow for the highest unit
        number /= 1024 ** exponent
      end

      "#{number} #{FILESIZE_UNITS[exponent]}"
    end
  end
end