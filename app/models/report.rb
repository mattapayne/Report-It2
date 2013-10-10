class Report
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::TagsArentHard
  include SimpleEnum::Mongoid
  include ::ImageContainingModel
  include ::TaggedModel
  
  field :name
  field :content
  field :description
  field :images, type: Array
  
  as_enum :status, draft: 0, published: 1
  as_enum :report_type, report: 0, template: 1
  belongs_to :creator, class_name: 'User'
  belongs_to :last_edited_by, class_name: 'User'
  belongs_to :report_template, class_name: 'Report'
  taggable_with :tags
  
  #validation
  validates_presence_of :name, :content, :creator, :report_type

  #callbacks
  after_initialize :set_status
  after_destroy :remove_shares
  after_create :add_to_creator
  
  def self.search(searchInfo)
    user = searchInfo.current_user
    if searchInfo.report_type == :report
      query = user.all_reports
    else
      query = user.all_templates
    end
    if searchInfo.tags.present?
      #this limits to reports that have all the selected tags. The alternative is 'any_in' which
      #would get all reports that had any of the selected tags
      if searchInfo.all_in_tags == true
        query = query.all_in(tags: searchInfo.tags)
      else
        query = query.any_in(tags: searchInfo.tags) 
      end
    end
    if searchInfo.search_term.present?
      query = query.any_in(name: Regexp.new("^#{searchInfo.search_term}.*"))
    end
    if searchInfo.status.present?
      converted_status = Report.statuses_enum_hash[searchInfo.status.to_sym]
      query = query.where(status_cd: converted_status)
    end
    query = query.page(searchInfo.page_number).limit(searchInfo.per_page)
    query
  end
  
  def self.copy(current_user, other)
    Report.create!({
      creator: current_user,
      name: "Copy of: #{other.name}",
      content: other.content,
      report_type: other.report_type,
      description: other.description,
      tags: other.tags
    })
  end
  
  def share_with!(user)
    if owner?(user)
      raise "This report cannot be shared with #{user.full_name}, because the user is the creator."
    end
    if shared_with?(user)
      raise "This report is already being shared with #{user.full_name}."
    end
    ensure_associated!(user)
    user.add_to_set(reports: self.id)
  end
  
  def unshare_with!(user)
    unless owner?(user)
      if shared_with?(user)
        user.pull(reports: self.id)
      end
    end
  end
  
  def owned_by_or_shared_with?(user)
    owner?(user) || shared_with?(user)
  end
  
  def shared_with?(user)
    user.reports.present? && user.reports.include?(self.id)
  end
  
  def owner?(user)
    self.creator.id == user.id
  end
  
  def get_shares(requesting_user)
    users = User.any_in(reports: self.id)
    unless users.present?
      users = []
    end
    users = users.reject {|u| u.id == requesting_user.id } #exclude the requesting user
    users
  end
  
  private
  
  def remove_shares
    User.any_in(reports: self.id).pull(reports: self.id)
  end
  
  def add_to_creator
    self.creator.add_to_set(reports: self.id)
  end
  
  def set_status
    self.status ||= :draft
  end
  
  def ensure_associated!(user)
    unless self.creator.associated_with?(user)
      raise "The user: #{user.full_name} is not an associate of #{self.creator.full_name}"
    end
  end

end
