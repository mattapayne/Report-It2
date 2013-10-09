class SimpleUserSerializer < ActiveModel::Serializer
  attributes :id, :gravatar_url, :email, :full_name
  
  def id
    object.id.to_s
  end
end
