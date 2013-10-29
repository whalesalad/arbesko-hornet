module Hornet
  class ImageProcessor
    attr_accessor :file_path
    attr_reader :model_number, :file_size, :image_data

    def initialize(file_path)
      @file_path = file_path
    end

    def inspect
      "#<Hornet::ImageProcessor - Model #{model_number}, #{file_size}>"
    end

    def model_number
      filename = File.basename(file_path)
      @model_number ||= filename.match(/[a-zA-Z]+_(?<model_number>\d+)/)[:model_number].to_i
    end

    def file_size
      @file_size ||= Hornet::Filesize.new(file_path).file_size
    end

    def process!
      Hornet.logger.info "Starting on #{model_number}..."

      clean! unless @cleaned

      # Large
      convert :large, :png
      convert :large, :jpg

      # Medium
      convert :medium, :png
      convert :medium, :jpg

      # Small
      convert :small, :png
      convert :small, :jpg

      # PDF Mask
      convert :mask, :png

      # PDF Image
      # convert :pdf, :png
    
      cleanup
    end

    def path_for(location, extension)
      File.join(OUTPUT_DIR, location.to_s, "#{model_number}.#{extension.to_s}")
    end

    def convert(size, extension)
      slug = size.to_s
      max_dimension = Hornet::IMAGE_SIZES[size]
      
      args = ["-resize #{max_dimension}x#{max_dimension}"]
      
      if extension == :jpg
        args << "-background white -flatten +matte"
      end

      command = Subexec.run "convert #{@cleaned} #{args.join(' ')} #{path_for(size, extension)}"
      if command.exitstatus == 0
        Hornet.logger.info "Finished #{slug.capitalize} #{extension.to_s.upcase} for #{model_number}."
      end
    end

  private

    def clean!
      output_path = File.join(Hornet::TMP_DIR, "temp_#{model_number}.png")

      if File.file?(output_path)
        @cleaned = output_path and return
      end
      
      Hornet.logger.info "Cleaning ..."

      sub = Subexec.run "convert #{file_path} -gravity South -trim +repage #{output_path}"
      if sub.exitstatus == 0
        Hornet.logger.info "Finished cleaning #{model_number}, saved clean PNG to #{output_path}."
        @cleaned = output_path
      end
    end

    def cleanup
      if @cleaned
        File.delete(@cleaned)
        Hornet.logger.info "Cleaned up after #{model_number}, removed #{@cleaned}."
      end
    end

  end
end