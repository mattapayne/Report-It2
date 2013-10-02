class ReportSerializer < ActiveModel::Serializer
  attributes :id, :name, :shared_with_current_user, :shared_by
  
  def id
    object.id.to_s
  end
  
  def shared_by
    if shared_with_current_user
      object.creator.full_name
    end
  end
  
  def shared_with_current_user
    object.creator.id != scope.id
  end
  
end
