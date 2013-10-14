class Notification
  include Mongoid::Document
  include SimpleEnum::Mongoid
  include Mongoid::Timestamps
  
  field :message
  as_enum :status, not_seen: 0, seen: 1
  belongs_to :initiator, class_name: 'User', inverse_of: :notifications_initiated
  belongs_to :receiver, class_name: 'User', inverse_of: :notifications_received
  
end
