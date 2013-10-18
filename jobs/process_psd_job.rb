require 'sucker_punch'
require 'mini_magick'

require_relative '../config'

SuckerPunch.logger = Logger.new('logs/process_psd')

class ProcessPSDJob
  include SuckerPunch::Job
  workers 4

  def perform(filename)
    model_number = model_number_from_filename(filename)
    
    file_path = File.join(PSD_DIR, filename)
    file_size = File.size(file_path).to_f / 2**20

    puts file_path
    puts "Processing images for model #{model_number} (#{file_size}mb)..."
    
    # TIFF/PNG
    f = File.open(file_path, 'rb')
    tiff_data = f.read
    f.close

    create_images_from_image_data(tiff_data, model_number)
  end

  def model_number_from_filename(filename)
    filename.match(/[A-Z]+_(?<model_number>\d+)/)[:model_number].to_i
  end

  def new_base_image_from_data(data)
    img = MiniMagick::Image.read(data)
    img.fuzz '20%'
    img.gravity 'South'
    img.trim
    img << "+repage"
    return img
  end

  def create_images_from_image_data(data, model_number)
    large = new_base_image_from_data(data)
    large.resize "700"
    large.format "png"
    save_image(large, 'large', "#{model_number}.png")
    large.background "white"
    large.flatten
    large.format "jpg"
    save_image(large, 'large', "#{model_number}.jpg")

    medium = new_base_image_from_data(data)
    medium.resize "250"
    medium.format "png"
    save_image(medium, 'medium', "#{model_number}.png")
    medium.background "white"
    medium.flatten
    medium.format "jpg"
    save_image(medium, 'medium', "#{model_number}.jpg")

    small = new_base_image_from_data(data)
    small.resize "150"
    small.format "png"
    save_image(small, 'small', "#{model_number}.png")
    small.background "white"
    small.flatten
    small.format "jpg"
    save_image(small, 'small', "#{model_number}.jpg")

    # Create alpha mask PNG for PDF system
    mask = new_base_image_from_data(data)
    mask.resize '900'
    mask.alpha 'extract'
    mask.format "png"
    save_image(mask, 'mask', "#{model_number}.png")

    # Create flattened non-alpha JPG for PDF system
    pdf = new_base_image_from_data(data)
    pdf.resize '900'
    pdf.background '#000000'
    pdf.flatten
    pdf.format "jpg"
    save_image(pdf, 'pdf', "#{model_number}.jpg")
  end

  def save_image(image, folder, filename)
    image.write(File.join(OUTPUT_DIR, folder, filename))
    puts "Wrote #{filename} to #{File.join(OUTPUT_DIR, folder)}."
  end

end