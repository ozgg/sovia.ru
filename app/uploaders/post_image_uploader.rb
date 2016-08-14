class PostImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::BombShelter

  storage :file

  def max_pixel_dimensions
    [3840, 3840]
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id/10000.floor}/#{model.id/100.floor}/#{model.id}"
  end

  process :auto_orient

  def auto_orient
    manipulate! do |image|
      image.tap(&:auto_orient)
    end
  end

  resize_to_fit 1280, 720

  version :big do
    resize_to_fit 640, 360
  end

  version :small, from_version: :big do
    resize_to_fit 320, 180
  end

  version :preview, from_version: :small do
    resize_to_fit 160, 90
  end

  def extension_white_list
    %w(jpg jpeg png)
  end
end
