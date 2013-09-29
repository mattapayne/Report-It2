class SharedReport
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :shared_with, class_name: 'User', inverse_of: :reports_shared_with_me
  belongs_to :shared_by, class_name: 'User', inverse_of: :reports_shared_by_me
  belongs_to :report
  
  validates_presence_of :shared_with, :shared_by, :report
  
  #eager load the report, since we will always care about it
  SharedReport.includes(:report)
  
end
