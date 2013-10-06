class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  
  field :first_name
  field :last_name
  field :email
  field :gravatar_url
  field :password_digest
  field :signup_token
  field :reports, type: Array
  field :associates, type: Array
  
  has_secure_password
  
  embeds_many :settings, class_name: 'UserSetting'
  
  has_many :associate_invitations_sent, class_name: 'AssociateInvitation', inverse_of: :inviter, dependent: :delete 
  has_many :associate_invitations_received, class_name: 'AssociateInvitation', inverse_of: :invitee, dependent: :delete #Think about this one
  
  has_many :snippets, dependent: :delete
  has_many :password_reset_requests, dependent: :delete
  
  validates_presence_of :first_name, :last_name, :email
  validates_format_of :email, with: Mongoid::Document::email_regex, on: :create
  validates_length_of :password, minimum: 6, on: :create
  validates_uniqueness_of :email
  
  before_create :add_default_settings, :add_signup_token, :set_gravatar_url
  after_initialize :initialize_reports, :initialize_associates
  
  def report_tags
    tags = all_reports.map {|r| r.tags }.flatten.compact.uniq
    tags
  end
  
  def template_tags
    all_templates.map {|r| r.tags }.flatten.compact.uniq
  end
  
  def all_templates(tags=nil)
    get_reports_by_type(:template, tags)
  end
  
  def all_reports(tags=nil)
   get_reports_by_type(:report, tags)
  end
  
  def email_taken?
    errors.full_messages.include?('Email is already taken')
  end
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  
  def must_validate_account?
    !self.signup_token.nil?
  end
  
  def account_validated!
    self.signup_token = nil
  end 
  
  def associated_with?(user)
    self_associates = self.associates || []
    user_associates = user.associates || []
    self_associates.include?(user.id) && user_associates.include?(self.id)
  end
  
  def disassociate_with!(user)
    self.pull(associates: user.id)
    user.pull(associates: self.id)
  end
  
  def associate_with!(user)
    unless associated_with?(user)
      self.add_to_set(associates: user.id)
      user.add_to_set(associates: self.id)
      invitation = nil
      if has_invited?(user)
        invitation = self.get_invitation(user)
      else
        invitation = user.get_invitation(self)
      end
      unless invitation.nil?
        invitation.status = :accepted
        invitation.save!
      end
    end
  end
  
  def get_associates
    ids = self.associates || []
    associated_users = User.find(ids)
    return associated_users || []
  end
  
  def invite_to_associate!(user, message = nil)
    if user.id == self.id
      raise 'You cannot invite yourself to associate.'
    end
    if associated_with?(user)
      raise 'You are already associated with this user.'
    end
    if has_invited?(user)
      raise 'You have already invited this user to associate.'
    end
    self.associate_invitations_sent.create!(invitee: user, message: message)
  end
  
  def has_invited?(user)
    get_invitation_query(user).exists?
  end
  
  def get_invitation(user)
    get_invitation_query(user).first
  end
  
  def get_value_for_setting(key)
    setting = self.settings.where(key: key).first
    return nil if setting.nil?
    return setting.value
  end
  
  private
  
  def initialize_reports
    self.reports ||= []
  end
  
  def initialize_associates
    self.associates ||= []
  end

  def get_reports_by_type(report_type, tags = nil)
    converted_report_type = Report.report_types_enum_hash[report_type.to_sym]
    query = Report.any_in(id: self.reports).where(report_type_cd: converted_report_type)
    unless tags.nil?
      query = query.all_in(tags: tags)
    end
    query = query.asc(:name)
    query
  end
  
  def set_gravatar_url
    gravatar_id = Digest::MD5.hexdigest(self.email.downcase)
    self.gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}.png"
  end
  
  def add_signup_token
    self.signup_token = SecureRandom.uuid
  end
  
  def add_default_settings
    UserSetting.default_settings.each do |setting|
      self.settings << setting
    end
  end

  def get_invitation_query(user)
    self.associate_invitations_sent.where(invitee: user)
  end
  
end
