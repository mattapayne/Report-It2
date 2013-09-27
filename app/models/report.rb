class Report
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::TagsArentHard
  include ::ShareableModel
  include SimpleEnum::Mongoid
  
  field :name
  field :content
  field :description
  field :images, type: Array
  
  as_enum :status, draft: 0, published: 1
  belongs_to :creator, class_name: 'User'
  belongs_to :report_template
  has_many :shares, class_name: 'SharedReport'
  taggable_with :tags
  
  validates_presence_of :name, :content, :creator

  before_create :set_status
  
  protected
  
  #overrides a hook method in ::ShareableModel to ensure that all relationships are removed
  def before_destroy_share(user, share)
    self.creator.reports_shared_by_me.delete(share)
    user.reports_shared_with_me.delete(share)
  end
  
  private
  
  def set_status
    self.status = :draft
  end
  
end
