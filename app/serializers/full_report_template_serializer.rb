class FullReportTemplateSerializer < ActiveModel::Serializer
  attributes :id, :name, :client, :content, :description, :created_at, :updated_at, :organization_ids
  
  def id
    object.id.to_s
  end
  
  def organization_ids
    object.organizations.map(&:id.to_s)
  end
end
