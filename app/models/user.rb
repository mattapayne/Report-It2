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
  has_many :associate_invitations_received, class_name: 'AssociateInvitation', inverse_of: :invitee
  
  has_many :snippets, dependent: :delete
  has_many :password_reset_requests, dependent: :delete
  
  validates_presence_of :first_name, :last_name, :email
  validates_format_of :email, with: Mongoid::Document::email_regex, on: :create
  validates_length_of :password, minimum: 6, on: :create
  validates_uniqueness_of :email
  
  before_create :add_default_settings, :add_signup_token, :set_gravatar_url
  after_initialize :initialize_reports, :initialize_associates
  
  def get_invitations(searchInfo)
    query = searchInfo.type == :sent ? self.associate_invitations_sent : self.associate_invitations_received
    if searchInfo.type == :received
      converted_status = AssociateInvitation.statuses_enum_hash[:pending]
      query = query.any_in(status_cd: [converted_status])
    end
    query = query.page(searchInfo.page_number).limit(searchInfo.per_page)
    query
  end
  
  def get_reports_shared_with(user)
    Report.where(creator_id: self.id).any_in(id: user.reports)
  end
  
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
  
  def get_associates(searchInfo=nil)
    query = User.any_in(id: self.associates.select {|id| id != self.id})
    if searchInfo.present?
      query = query.page(searchInfo.page_number).limit(searchInfo.per_page)
    end
    query
  end
  
  def get_potential_associates(filter = nil)
    not_associates = User.not_in(id: self.associates)
    if filter.present?
      not_associates = not_associates.any_in(email: Regexp.new("^#{filter}.*"))
    end
    #we need to exclude those that have already been invited, but who have not accepted or declined
    invited_but_pending = get_pending_invited_associates().map(&:invitee_id).compact.map { |id| id.to_s }
    not_associates = not_associates.delete_if {|u| invited_but_pending.include?(u.id.to_s)}
    not_associates
  end
  
  def get_pending_invited_associates
    converted_status = AssociateInvitation.statuses_enum_hash[:pending]
    self.associate_invitations_sent.any_in(status_cd: [converted_status]).where(new_invitee: false)
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
    self.associate_invitations_sent.create!(invitee: user, message: message, new_invitee: false, invitee_email: user.email)
  end
  
  def invite_to_associate_with_new_user!(email, message)
    if has_invited_new?(email)
      raise 'You have already invited this user to associate.'
    end
    self.associate_invitations_sent.create!(invitee_email: email, message: message, new_invitee: true)
  end
  
  def has_invited?(user)
    get_invitation_query(user).exists?
  end
  
  def has_invited_new?(email)
    get_invitation_by_email_query(email).exists?
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
    self.associate_invitations_sent.where(invitee: user).where(new_invitee: false)
  end
  
  def get_invitation_by_email_query(email)
    self.associate_invitations_sent.where(invitee_email: email).where(new_invitee: true)
  end
  
end
