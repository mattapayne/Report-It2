class MyProfileUploader < CarrierWave::Uploader::Base
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
    resize_to_fill(MyProfileImage::HEIGHT, MyProfileImage::WIDTH)
  end
  
  def secure_token
    SecureRandom.uuid
  end
  
end