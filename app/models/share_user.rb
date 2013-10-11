class ShareUser
  include ActiveModel::Model
  include ActiveModel::SerializerSupport 
  
  attr_accessor :id, :default_image, :email, :has_share, :full_name
  
end