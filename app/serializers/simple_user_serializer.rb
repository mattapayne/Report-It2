class SimpleUserSerializer < ActiveModel::Serializer
  attributes :id, :default_image, :email, :full_name
  
  def id
    object.id.to_s
  end
end
