module ImageContainingModel
  extend ActiveSupport::Concern
  
  IMAGE_URL_REGEX = /(?<filename>.{36}\.(jpg|jpeg|gif|png))/i
  
  included do
    before_save :set_images
    after_destroy :remove_images
  end

  protected
  
  def set_images
    self.images = get_image_names
  end
  
  def remove_images
    #No plan for this yet. It only matters in production.
    #maybe we create a simple collection of images to be removed and have an offline service delete them
  end
  
  def model_name
    return self.class.name.titleize.downcase
  end
  
  private
  
  def get_image_names
    if self.respond_to?(:content)
      return self.content.scan(IMAGE_URL_REGEX).map {|match| match.first }.uniq.to_a
    end
    nil
  end
end
