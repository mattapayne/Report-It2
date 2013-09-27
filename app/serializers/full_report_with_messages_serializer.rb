class FullReportWithMessagesSerializer < ActiveModel::Serializer
  attributes :messages, :report
  
  def messages
    object[:messages]
  end
  
  def report
      serializer = FullReportSerializer.new(object[:report], { root: false })
      serializer.serializable_hash
  end
end
