class FullReportTemplateWithMessagesSerializer < ActiveModel::Serializer
  attributes :messages, :report_template
  
  def messages
    object[:messages]
  end
  
  def report_template
      serializer = FullReportTemplateSerializer.new(object[:report_template], { root: false })
      serializer.serializable_hash
  end
end
