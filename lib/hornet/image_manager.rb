module Hornet
  class ImageManager
    attr_accessor :file_path, :type
    attr_reader :model_number, :file_size, :image_data

    def initialize(type, path)
      @type = type
      @file_path = path
    end

    def inspect
      "#<Hornet::ImageManager - Model #{model_number}>"
    end

    def model_number
      filename = File.basename(file_path)
      @model_number ||= filename.match(/[A-Z]+_(?<model_number>\d+)/)[:model_number].to_i
    end

    def file_size
      @file_size ||= Hornet::Filesize.new(@file_path).file_size
    end

    def clean!
      output_path = File.join(Hornet::TMP_DIR, "temp_#{model_number}.png")

      if File.file?(output_path)
        @cleaned = output_path
        return
      end
      
      puts "Cleaning #{model_number}."

      sub = Subexec.run "convert #{file_path} -fuzz 20% -gravity South -trim +repage #{output_path}"
      if sub.exitstatus == 0
        puts "Finished cleaning #{model_number}, saved clean PNG to #{output_path}."
        @cleaned = output_path
      end
    end

    def process!
      self.clean! unless @cleaned

      puts "Processing images for model #{model_number} (#{file_size})..."

      # Large
      Subexec.run "convert #{@cleaned} -resize 700 #{path_for(:large, :png)}"
      Subexec.run "convert #{@cleaned} -resize 700 -background white -flatten +matte #{path_for(:large, :jpg)}"

      # Medium
      Subexec.run "convert #{@cleaned} -resize 250 #{path_for(:medium, :png)}"
      Subexec.run "convert #{@cleaned} -resize 250 -background white -flatten +matte #{path_for(:medium, :jpg)}"

      # Small
      Subexec.run "convert #{@cleaned} -resize 150 #{path_for(:small, :png)}"
      Subexec.run "convert #{@cleaned} -resize 150 -background white -flatten +matte #{path_for(:small, :jpg)}"

      # PDF Mask
      Subexec.run "convert #{@cleaned} -alpha extract #{path_for(:mask, :png)}"

      # PDF Image
      Subexec.run "convert #{@cleaned} -background black -flatten +matte #{path_for(:pdf, :png)}"
    end

    def path_for(location, extension)
      File.join(OUTPUT_DIR, type, location.to_s, "#{model_number}.#{extension.to_s}")
    end
  end
end