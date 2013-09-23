class ReportTemplate
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  field :content
  field :description
  field :client
  field :images, type: Array
  
  belongs_to :creator, class_name: 'User'
  has_many :reports
  has_and_belongs_to_many :organizations
end
