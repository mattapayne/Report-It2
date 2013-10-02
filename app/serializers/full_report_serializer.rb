class FullReportSerializer < ActiveModel::Serializer
  attributes :id, :name, :content, :description, :created_at, :updated_at, :new_record, :tags, :shared_with_current_user, :shared_by, :report_type, :last_edited_by
  
  def id
    object.id.to_s
  end
  
  def last_edited_by
    object.last_edited_by.present? ? object.last_edited_by.full_name : nil
  end
  
  def shared_by
    if shared_with_current_user
      object.creator.full_name
    end
  end
  
  def shared_with_current_user
    object.creator.id != scope.id
  end

  def new_record
    object.new_record || false
  end
  
end
