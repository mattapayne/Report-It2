class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :from, :message, :created_at
  
  def id
    object.id.to_s
  end
  
  def from
    object.initiator.full_name
  end
  
  def created_at
    object.created_at.present? ? object.created_at.strftime("%m/%d/%Y at %I:%M %p") : nil
  end
  
end
