class ShareUser
  include ActiveModel::Model
  include ActiveModel::SerializerSupport 
  
  attr_accessor :id, :gravatar_url, :email, :has_share, :full_name
  
end