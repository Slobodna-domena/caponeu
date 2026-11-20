class PersonPhotoUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_allowlist
    %w(jpg jpeg png)
  end

  version :big do
    resize_to_fit(800,nil)
  end

  version :compact do
    resize_to_fit(367,nil)
  end

end
