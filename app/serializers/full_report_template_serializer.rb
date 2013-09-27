class FullReportTemplateSerializer < ActiveModel::Serializer
  attributes :id, :name, :client, :content, :description, :created_at, :updated_at
  
  def id
    object.id.to_s
  end

end
