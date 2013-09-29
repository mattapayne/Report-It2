class ReportTemplateSerializer < ActiveModel::Serializer
  attributes :id, :name, :shared, :shared_by
  
  def id
    object.id.to_s
  end
  
  def shared_by
    if shared
      object.creator.full_name
    end
  end
  
  def shared
    object.creator.id != scope.id
  end
    
end
