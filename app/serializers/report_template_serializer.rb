class ReportTemplateSerializer < ActiveModel::Serializer
  attributes :id, :name, :client
  
  def id
    object.id.to_s
  end
    
end
