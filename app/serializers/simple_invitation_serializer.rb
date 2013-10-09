class SimpleInvitationSerializer < ActiveModel::Serializer
  attributes :id, :from_id, :to_id, :from_email, :from_name, :to_email, :to_name, :created_at, :status, :message, :new_invitee
  
  def id
    object.id.to_s
  end
  
  def created_at
    object.created_at.strftime("%m/%d/%Y at %I:%M %p")
  end
  
  def from_id
    object.inviter_id.to_s
  end
  
  def to_id
    object.invitee_id.present? ? object.invitee_id.to_s : nil 
  end
  
  def from_email
    object.inviter.email
  end
  
  def from_name
    object.inviter.full_name
  end
  
  def to_name
    object.invitee_id.present? ? object.invitee.full_name : object.invitee_email
  end
  
  def to_email
    object.invitee_email
  end
  
end
