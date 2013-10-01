class ReportTemplatesController < ApplicationController
  before_action :require_login
  before_action :load_report_template, only: [:update, :destroy, :edit, :edit_json, :shares]
  before_action :construct_tag_filter, only: [:index]
  
  def index
    case @tag_filter
      when nil
        reports = []
      when ['all'] #Ugh!
        reports = current_user.all_templates
      else
        reports = current_user.all_templates(@tag_filter)
    end
    render json: reports.to_a
  end
  
  def shares
    #associates with whom the report template has been shared
    @current_sharees = @report_template.get_shares(current_user) || []
    #associates with whom the report template has not been shared
    @potential_sharees = current_user.get_associates.reject { |u| @report_template.shared?(u) }
    render json: Shares.new(@current_sharees, @potential_sharees), serializer: SharesSerializer
  end
  
  def update_share
    @user = User.find(params_for_share[:user_id])
    @shared = params_for_share[:shared]
    @report_template = ReportTemplate.find(params_for_share[:report_template_id])
    
    if @shared
      @report_template.share_with!(@user)
    else
      @report_template.unshare_with!(@user)
    end
    render nothing: true, status: 200
  end
  
  def new
    
  end
  
  def edit
    
  end
  
  def create
    @report_template = ReportTemplate.create(params_for_report_template.merge(creator: current_user))
    if @report_template.save
      @result = ReportTemplateWithMessages.new(['Successfully created the report template.'], @report_template)
      render json: @result, serializer: ReportTemplateWithMessagesSerializer
    else
      render json: { messages: @report_template.errors.full_messages }, status: 406
    end
  end
  
  def update
    if @report_template.update_attributes(params_for_report_template)
      @result = ReportTemplateWithMessages.new(['Successfully updated the report template.'], @report_template)
      render json: @result, serializer: ReportTemplateWithMessagesSerializer
    else
      render json: { messages: @report_template.errors.full_messages }, status: 406
    end
  end
  
  def destroy
    if @report_template.destroy #Use destroy to ensure callbacks are fired, as deleted does not fire them
      render json: { messages: ["Successfully deleted report template: '#{@report_template.name}'."]}
    else
      render json: { messages: @report_template.errors.full_messages }, status: 406
    end
  end
  
  def new_json
    @report_template = ReportTemplate.new(creator: current_user)
    render json: @report_template, serializer: FullReportTemplateSerializer
  end
  
  def edit_json
    render json: @report_template, serializer: FullReportTemplateSerializer
  end
  
  protected
  
  def get_title(action)
    "#{super} :: Report Templates"
  end
  
  private
  
  def construct_tag_filter
    unless params_for_report_template_filters.nil?
      @tag_filter = params_for_report_template_filters.split(',')
    end
  end
  
  def params_for_share
    params.require(:share).permit(:user_id, :report_template_id, :shared)
  end
  
  def params_for_report_template_filters
    return params.require(:tags) if params[:tags].present?
  end
  
  def params_for_report_template
    params.require(:report_template).permit(:name, :description, :content, tags: [])
  end
  
  def load_report_template
    @report_template = ReportTemplate.find(params[:id])
    unless @report_template && @report_template.owned_by_or_shared_with?(current_user)
      render_not_allowed_json_response("You do not have permission to access this report template.") and return
    end
    @report_template_id = @report_template.id
  end
end
