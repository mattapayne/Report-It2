class Snippet
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  field :content
  
  belongs_to :creator, class_name: 'User'
  
  validates_presence_of :creator, :name, :content
end
