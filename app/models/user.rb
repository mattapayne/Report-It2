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
  
  has_many :associate_invitations_sent, class_name: 'AssociateInvitation', inverse_of: :inviter, dependent: :delete 
  has_many :associate_invitations_received, class_name: 'AssociateInvitation', inverse_of: :invitee, dependent: :delete #Think about this one
  
  has_many :snippets, dependent: :delete
  has_many :password_reset_requests, dependent: :delete
  has_many :associates, class_name: 'UserAssociation', dependent: :delete, inverse_of: :user
  
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
    mine = my_reports
    shared_with_me = reports_shared_with_me.map { |share| share.report }
    
    unless tags.nil?
      mine = mine.all_in(tags: tags)
      shared_with_me = shared_with_me.select { |r| r.has_all_tags?(tags) }
    end
    
    all = mine.to_a.concat(shared_with_me.to_a).compact
    all
  end
  
  def all_templates(tags=nil)
    mine = my_templates
    shared_with_me = templates_shared_with_me.map { |share| share.report_template }
    
    unless tags.nil?
      mine = mine.all_in(tags: tags)
      shared_with_me = shared_with_me.select { |t| t.has_all_tags?(tags) }
    end
    
    all = mine.to_a.concat(shared_with_me.to_a).compact
    all
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
    associates.where(associate: user).exists?
  end
  
  def disassociate_with!(user)
    self.associates.where(associate: user).delete_all
    user.associates.where(associate: self).delete_all
  end
  
  def associate_with!(user)
    unless associated_with?(user)
      associates.create!(associate: user)
      user.associates.create!(associate: self)
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
