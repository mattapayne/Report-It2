class FullReportSerializer < ActiveModel::Serializer
  attributes :id, :name, :creator_id, :content, :description, :created_at, :updated_at, :new_record, :report_template_id,
    :tags, :shared_with_current_user, :shared_by, :report_type, :last_edited_by, :report_types, :status, :status_types,
    :header, :footer
  
  def id
    object.id.to_s
  end
  
  def creator_id
    object.creator.id.to_s
  end
  
  def status_types
    Report.statuses_for_select.map {|item| {value: item[1], name: item[0]}}
  end
  
  def report_types
    Report.report_types_for_select.map {|item| {value: item[1], name: item[0]}}
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
