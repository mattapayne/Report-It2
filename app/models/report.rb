class Report
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::TagsArentHard
  include ::ShareableModel
  include SimpleEnum::Mongoid
  include ::ImageContainingModel
  include ::TaggedModel
  
  user_shared_collection_name :reports
  
  field :name
  field :content
  field :description
  field :images, type: Array
  
  as_enum :status, draft: 0, published: 1
  belongs_to :creator, class_name: 'User'
  belongs_to :report_template
  taggable_with :tags
  
  validates_presence_of :name, :content, :creator

  before_create :set_status
  
  private
  
  def set_status
    self.status = :draft
  end

end
