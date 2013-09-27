class UserAssociation
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :user
  belongs_to :associate, class_name: 'User'
  
  validates_presence_of :user, :associate
end
