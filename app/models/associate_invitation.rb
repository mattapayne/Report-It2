class AssociateInvitation
  include Mongoid::Document
  include Mongoid::Timestamps
  include SimpleEnum::Mongoid
  
  field :message
  as_enum :status, pending: 0, accepted: 1, declined: 2
  belongs_to :inviter, class_name: 'User', inverse_of: :associate_invitations_sent
  belongs_to :invitee, class_name: 'User', inverse_of: :associate_invitations_received
  
  validates_presence_of :inviter, :invitee
  
  before_create :set_status
  
  def set_status
    self.status = :pending
  end
end
