class Report
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  field :content
  field :description
  field :client
  field :images, type: Array
  
  belongs_to :creator, class_name: 'User'
  belongs_to :report_template
  has_and_belongs_to_many :organizations
end
