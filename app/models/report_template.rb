class ReportTemplate
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::TagsArentHard
  include ::ShareableModel
  
  field :name
  field :content
  field :description
  field :images, type: Array
  
  belongs_to :creator, class_name: 'User'
  has_many :reports
  has_many :shares, class_name: 'SharedReportTemplate', dependent: :destroy
  taggable_with :tags
  
  validates_presence_of :name, :content
  
  protected
  
  #overrides a hook method in ::ShareableModel to ensure that all relationships are removed
  def before_destroy_share(user, share)
    self.creator.templates_shared_by_me.delete(share)
    user.templates_shared_with_me.delete(share)
  end
end
