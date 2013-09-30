class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  
  field :first_name
  field :last_name
  field :email
  field :password_digest
  field :signup_token
  field :reports, type: Array # => collection of report ids - those created by the user and those shared with the user
  field :report_templates, type: Array# => collection of report template ids - those created by the user and those shared with the user
  field :associates, type: Array# => collection of user ids that are associated with this user
  
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
  
  before_create :add_default_settings, :add_signup_token
  
  def report_tags
    all_reports.map {|r| r.tags }.flatten.compact.uniq
  end
  
  def template_tags
    all_templates.map {|r| r.tags }.flatten.compact.uniq
  end
  
  def all_reports(tags=nil)
    query = Report.any_in(id: self.reports)
    unless tags.nil?
      query = query.all_in(tags: tags)
    end
    return query
  end
  
  def all_templates(tags=nil)
    query = ReportTemplate.any_in(id: self.report_templates)
    unless tags.nil?
      query = query.all_in(tags: tags)
    end
    return query
  end
  
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
    self.get_invitation_query(user).exists?
  end
  
  def get_invitation(user)
    self.get_invitation_query(user).first
  end
  
  def get_value_for_setting(key)
    setting = self.settings.where(key: key).first
    return nil if setting.nil?
    return setting.value
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

  def get_invitation_query(user)
    self.associate_invitations_sent.where(invitee: user)
  end
  
end
