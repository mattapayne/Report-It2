class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  
  field :first_name
  field :last_name
  field :email
  field :password_digest
  field :signup_token
  
  has_secure_password
  
  embeds_many :settings, class_name: 'UserSetting'
  has_many :organizations, dependent: :nullify #Not sure on this one yet
  has_many :reports, dependent: :delete
  has_many :report_templates, dependent: :delete
  has_many :snippets, dependent: :delete
  has_many :password_reset_requests, dependent: :delete
  
  validates_presence_of :first_name, :last_name, :email
  validates_format_of :email, with: Mongoid::Document::email_regex, on: :create
  validates_length_of :password, minimum: 6, on: :create
  validates_uniqueness_of :email
  
  before_create :add_default_settings, :add_signup_token
  
  def email_taken?
    errors.full_messages.include?('Email is already taken')
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def must_validate_account?
    !signup_token.nil?
  end
  
  protected
  
  def add_signup_token
    self.signup_token = SecureRandom.uuid
  end
  
  def add_default_settings
    UserSetting.default_settings.each do |setting|
      self.settings << setting
    end
  end
  
end
