class ReportsController < ApplicationController
  before_action :require_login
  before_action :load_report, only: [:update, :destroy, :edit, :view]
  
  def index
    render json: current_user.my_reports.to_a
  end
  
  def new
    @report = nil
    @report_id = nil
    render :single
  end
  
  def create
    @report = current_user.my_reports.build(params_for_report)
    if @report.save
      render json: {
        messages: ['Successfully created the report.'],
        report: @report },
      serializer: FullReportWithMessagesSerializer
    else
      render json: { messages: @report.errors.full_messages }, status: 406
    end
  end
  
  def update
    if @report.update_attributes(params_for_report)
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
  
  def params_for_report
    params.require(:report).permit(:name, :description, :content, :report_template_id)
  end
  
  def load_report
    @report = current_user.my_reports.find(params[:id]) if params[:id]
  end
  
end
