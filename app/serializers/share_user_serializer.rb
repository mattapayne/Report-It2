class ShareUserSerializer < ActiveModel::Serializer
  attributes :id, :gravatar_url, :email, :has_share, :full_name
  
  def id
    object.id.to_s
  end
end
