class UserSettingSerializer < ActiveModel::Serializer
  attributes :id, :key, :value, :description, :validation_rule
  
  def id
    object.id.to_s
  end
  
end
