class FullReportSerializer < ActiveModel::Serializer
  attributes :id, :name, :client, :content, :description, :report_template_id, :created_at, :updated_at, :organization_ids
  
  def id
    object.id.to_s
  end
  
  def report_template_id
    object_report_template_id.to_s
  end
  
  def organization_ids
    object.organizations.map(&:id.to_s)
  end
  
end
