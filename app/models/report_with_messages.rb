class ReportWithMessages
  include ActiveModel::Model
  
  attr_accessor :messages, :report
  
  def initialize(messages, report)
      @messages = messages
      @report = report
  end
end
