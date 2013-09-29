class ReportTemplateWithMessages
  include ActiveModel::Model
  
  attr_accessor :messages, :report_template
  
  def initialize(messages, report_template)
      @messages = messages
      @report_template = report_template
  end
end
