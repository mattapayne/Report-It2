class PasswordResetRequest
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :password_digest
  field :reset_token
  
  attr_accessor :password, :password_confirmation, :email
  
  belongs_to :creator, class_name: 'User'
  
  before_create :set_reset_token, :set_password_digest
  
  validates_format_of :email, with: Mongoid::Document::email_regex, on: :create
  validates_confirmation_of :password, if: lambda { |m| m.password.present? }
  validates_presence_of     :password, on: :create
  validates_presence_of     :password_confirmation, if: lambda { |m| m.password.present? }
  
  private
  
  def set_reset_token
    self.reset_token = SecureRandom.uuid
  end
  
  def set_password_digest
    unless self.password.blank?
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine::DEFAULT_COST
      self.password_digest = BCrypt::Password.create(self.password, cost: cost)
    end
  end
end
