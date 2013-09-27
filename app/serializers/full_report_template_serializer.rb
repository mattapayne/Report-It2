class FullReportTemplateSerializer < ActiveModel::Serializer
  attributes :id, :name, :content, :description, :created_at, :updated_at, :new_record
  
  def id
    object.id.to_s
  end
  
  def new_record
    object.new_record || false
  end

end
