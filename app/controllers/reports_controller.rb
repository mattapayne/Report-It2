class ReportsController < ApplicationController
  before_action :require_login
  before_action :load_report, only: [:update, :destroy, :edit, :edit_json, :shares]
  before_action :construct_tag_filter, only: [:index]
  
  def index
    tag_filter  = params_for_report_filters.split(',') unless params_for_report_filters.nil?
    case tag_filter
      when nil
        reports = []
      when ['all'] #Ugh!
        reports = current_user.all_reports
      else
        reports = current_user.all_reports(tag_filter)
    end
    render json: reports.to_a
  end
  
  def create
    @report = Report.create(params_for_report.merge(creator: current_user))
    if @report.save
      @result = ReportWithMessages.new(['Successfully created the report.'], @report)
      render json: @result, serializer: ReportWithMessagesSerializer
    else
      render json: { messages: @report.errors.full_messages }, status: 406
    end
  end
  
  def update
    if @report.update_attributes(params_for_report)
      result = ReportWithMessages.new(['Successfully updated the report.'], @report)
      render json: result, serializer: ReportWithMessagesSerializer
    else
      render json: { messages: @report.errors.full_messages }, status: 406
    end
  end
  
  def destroy
    if @report.destroy #call destroy to ensure that callbacks are run, since delete does not run them
      render json: { messages: ["Successfully deleted report: '#{@report.name}'."]}
    else
      render json: { messages: @report.errors.full_messages }, status: 406
    end
  end
  
  def edit

  end
  
  def new
    
  end
  
  def shares
    #associates with whom the report template has been shared
    @current_sharees = @report.get_shares(current_user) || []
    #associates with whom the report template has not been shared
    @potential_sharees = current_user.get_associates.reject { |u| @report.shared?(u) }
    render json: Shares.new(@current_sharees, @potential_sharees), serializer: SharesSerializer
  end
  
  def update_share
    @user = User.find(params_for_share[:user_id])
    @shared = params_for_share[:shared]
    @report = Report.find(params_for_share[:report_id])
    
    if @shared
      @report.share_with!(@user)
    else
      @report.unshare_with!(@user)
    end
    render nothing: true, status: 200
  end
  
  def new_json
    @report = Report.new(creator: current_user)
    render json: @report, serializer: FullReportSerializer
  end
  
  def edit_json
    render json: @report, serializer: FullReportSerializer
  end
  
  protected
  
  def get_title(action)
    "#{super} :: Reports"
  end
  
  private
  
  def construct_tag_filter
    unless params_for_report_filters.nil?
      @tag_filter = params_for_report_filters.split(',')
    end
  end
  
  def params_for_share
    params.require(:share).permit(:user_id, :report_id, :shared)
  end
  
  def params_for_report_filters
    return params.require(:tags) if params[:tags].present?
  end
  
  def params_for_report
    params.require(:report).permit(:name, :description, :content, :report_template_id, tags: [])
  end
  
  def load_report
    @report = Report.find(params[:id]) if params[:id]
    unless @report && @report.owned_by_or_shared_with?(current_user)
      redirect_to dashboard_path and return
    end
    @report_id = @report.id
  end
  
end
