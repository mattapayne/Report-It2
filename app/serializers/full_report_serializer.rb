class FullReportSerializer < ActiveModel::Serializer
  attributes :id, :name, :content, :description, :report_template_id, :created_at, :updated_at, :new_record, :tags, :shared, :shared_by
  
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
  
  def report_template_id
    object.report_template_id.to_s
  end

  def new_record
    object.new_record || false
  end
  
end
