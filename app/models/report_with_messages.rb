class ReportWithMessages
  include ActiveModel::Model
  include ActiveModel::SerializerSupport 
  
  attr_accessor :messages, :report
  
  def initialize(messages, report)
      @messages = messages
      @report = report
  end
end
