class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  include Mongoid::TagsArentHard
  
  field :first_name
  field :last_name
  field :email
  field :password_digest
  field :signup_token
  
  has_secure_password
  
  embeds_many :settings, class_name: 'UserSetting'
  
  has_many :templates_shared_by_me, class_name: 'SharedReportTemplate', inverse_of: :shared_by, dependent: :delete
  has_many :templates_shared_with_me, class_name: 'SharedReportTemplate', inverse_of: :shared_with
  
  has_many :reports_shared_by_me, class_name: 'SharedReport', inverse_of: :shared_by
  has_many :reports_shared_with_me, class_name: 'SharedReport', inverse_of: :shared_with
  
  has_many :my_reports, class_name: 'Report', dependent: :delete
  has_many :my_templates, class_name: 'ReportTemplate', dependent: :delete
  has_many :snippets, dependent: :delete
  has_many :password_reset_requests, dependent: :delete
  has_many :associates, class_name: 'UserAssociation', dependent: :delete, inverse_of: :user
  
  taggable_with :tags
  
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
  
  def associated_with?(user)
    associates.where(associate: user).exists?
  end
  
  def disassociate_with!(user)
    association = associates.where(associate: user).first
    unless association.nil?
      association.delete
    end
    association = user.associates.where(associate: self).first
    unless association.nil?
      association.delete
    end
  end
  
  def associate_with!(user)
    unless associated_with?(user)
      associates.create!(associate: user)
      user.associates.create!(associate: self)
    end
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
