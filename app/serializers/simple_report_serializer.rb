class SimpleReportSerializer < ActiveModel::Serializer
  attributes :id, :name, :report_type, :friendly_report_type
  
  def id
    object.id.to_s
  end
  
  def friendly_report_type
    object.report_type.to_s.humanize.capitalize
  end
end
