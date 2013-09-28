class ReportsController < ApplicationController
  before_action :require_login
  before_action :load_report, only: [:update, :destroy, :edit, :view]
  
  def index
    tag_filter  = params_for_report_filters.split(',') unless params_for_report_filters.nil?
    reports = tag_filter.nil? ? [] : current_user.my_reports.all_in(tags: tag_filter)
    render json: reports.to_a
  end
  
  def new
    @report = nil
    @report_id = nil
    render :single
  end
  
  def create
    tags = params_for_report[:tags] if params_for_report[:tags].present?
    @report = current_user.my_reports.build(params_for_report)
    if @report.save
      update_user_tags(tags)
      render json: {
        messages: ['Successfully created the report.'],
        report: @report },
      serializer: FullReportWithMessagesSerializer
    else
      render json: { messages: @report.errors.full_messages }, status: 406
    end
  end
  
  def update
    tags = params_for_report[:tags] if params_for_report[:tags].present?
    if @report.update_attributes(params_for_report)
      update_user_tags(tags)
      render json: {
        messages: ['Successfully updated the report.'],
        report: @report },
      serializer: FullReportWithMessagesSerializer
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
    @report_id = @report.id.to_s
    render :single
  end
  
  def view
    #view handles getting either a new or a pre-existing one report, so we need to create a new one if
    #one was not found in the before_action of 'load_report'
    @report = current_user.my_reports.build if @report.nil?
    render json: @report, serializer: FullReportSerializer
  end
  
  protected
  
  def get_title(action)
    "#{super} :: Reports"
  end
  
  private
  
  def update_user_tags(tags)
    unless tags.nil?
      current_user.report_tags << tags
      current_user.save
    end
  end
  
  def params_for_report_filters
    return params.require(:tags) if params[:tags].present?
  end
  
  def params_for_report
    params.require(:report).permit(:name, :description, :content, :report_template_id, tags: [])
  end
  
  def load_report
    @report = current_user.my_reports.find(params[:id]) if params[:id]
  end
  
end
