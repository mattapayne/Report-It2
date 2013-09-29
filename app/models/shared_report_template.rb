class SharedReportTemplate
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :shared_with, class_name: 'User', inverse_of: :templates_shared_with_me
  belongs_to :shared_by, class_name: 'User', inverse_of: :templates_shared_by_me
  belongs_to :report_template
  
  validates_presence_of :shared_with, :shared_by, :report_template
  
  #eager load
  SharedReportTemplate.includes(:report_template)
end
