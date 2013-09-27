class FullReportSerializer < ActiveModel::Serializer
  attributes :id, :name, :content, :description, :report_template_id, :created_at, :updated_at
  
  def id
    object.id.to_s
  end
  
  def report_template_id
    object_report_template_id.to_s
  end
  
end
