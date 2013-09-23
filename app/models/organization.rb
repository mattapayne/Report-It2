class Organization
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  
  belongs_to :creator, class_name: 'User'
  has_and_belongs_to_many :reports
  has_and_belongs_to_many :report_templates
end
