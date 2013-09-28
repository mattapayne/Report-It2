module ImageContainingModel
  extend ActiveSupport::Concern
  
  IMAGE_URL_REGEX = /(?<filename>.{36}\.(jpg|jpeg|gif|png))/i
  
  included do
    before_save :set_images    
  end

  protected
  
  def set_images
    if self.respond_to?(:images)
      self.images = get_image_names
    end
  end
  
  private
  
  def get_image_names
    if self.respond_to?(:content)
      return self.content.scan(IMAGE_URL_REGEX).map {|match| match.first }.uniq.to_a
    end
    nil
  end
end
