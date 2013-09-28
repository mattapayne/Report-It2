class UserTagsController < ApplicationController
    before_action :require_login, :load_tags_by_type
    
  def index
    filter = params_for_filter
    filtered_tags = filter.nil? ? @tags : @tags.select { |t| t.downcase.contains?(filter) }
    filtered_tags = filtered_tags.map(&:downcase).uniq
    render json: filtered_tags.to_a
  end
    
  private
  
  def params_for_filter
    return params.require(:query) if params[:query].present?
    return nil
  end
  
  def load_tags_by_type
    @tags = []
    tag_type = params[:type]
    case tag_type
      when "report"
        @tags = current_user.report_tags
      when "template"
        @tags = current_user.template_tags
    end
  end
  
end
