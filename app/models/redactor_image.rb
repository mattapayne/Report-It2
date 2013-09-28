class RedactorImage
  extend CarrierWave::Mount
  mount_uploader :image, ImageUploader
  
  DEFAULT_HEIGHT = 360
  DEFAULT_WIDTH = 400
  
  def initialize(current_user)
    @current_user = current_user
  end
  
  def user_specific_height
    @height ||= (
    setting = self.current_user.get_value_for_setting('image_height')
    if setting.nil?
      DEFAULT_HEIGHT
    else
      setting.to_i
    end)
  end
  
  def user_specific_width
    @width ||= (
    setting = self.current_user.get_value_for_setting('image_width')
    if setting.nil?
      DEFAULT_WIDTH
    else
      setting.to_i
    end)
  end
  
  def current_user
    @current_user
  end
end
