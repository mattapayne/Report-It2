class ReportTemplate
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::TagsArentHard
  include ::ShareableModel
  include SimpleEnum::Mongoid
  include ::ImageContainingModel
  include ::TaggedModel
  
  #used by ShareableModel to determine the collection to look at on the user when operating on it
  user_shared_collection_name :report_templates
  
  field :name
  field :content
  field :description
  field :images, type: Array
  
  as_enum :status, draft: 0, published: 1
  belongs_to :creator, class_name: 'User'
  has_many :reports
  taggable_with :tags
  
  validates_presence_of :name, :content, :creator
  
  before_create :set_status
  
  private
  
  def set_status
    self.status = :draft
  end
  
end
