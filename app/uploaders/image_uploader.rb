# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::MimeTypes
  
  process :set_content_type, :resize
  
  def filename
     "#{secure_token}.#{file.extension}" if original_filename.present?
  end
  
  def extension_white_list
     %w(jpg jpeg gif png tif tiff)
  end
  
  protected
  
  def resize
    resize_to_fill(model.user_specific_width.to_i, model.user_specific_height.to_i)
  end
  
  def secure_token
    SecureRandom.uuid
  end
  
end
