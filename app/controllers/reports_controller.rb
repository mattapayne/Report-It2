class ReportsController < ApplicationController
  before_action :require_login
  before_action :load_report, only: [:update, :destroy, :edit, :edit_json]
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
    @report = current_user.my_reports.build(params_for_report)
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
    if @report.delete
      render json: { messages: ["Successfully deleted report: '#{@report.name}'."]}
    else
      render json: { messages: @report.errors.full_messages }, status: 406
    end
  end
  
  def edit

  end
  
  def new
    
  end
  
  def new_json
    @report = current_user.my_reports.build
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
  
  def params_for_report_filters
    return params.require(:tags) if params[:tags].present?
  end
  
  def params_for_report
    params.require(:report).permit(:name, :description, :content, :report_template_id, tags: [])
  end
  
  def load_report
    @report = Report.find(params[:id]) if params[:id]
    unless @report && @report.owned_or_shared_with?(current_user)
      redirect_to dashboard_path and return
    end
    @report_id = @report.id
  end
  
end
