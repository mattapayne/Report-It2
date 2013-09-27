class ReportTemplatesController < ApplicationController
  before_action :require_login
  before_action :load_report_template, only: [:update, :destroy, :edit, :view]
  
  def index
    render json: current_user.report_templates.to_a, status: 200
  end
  
  def new
    @report_template = nil
    @report_template_id = nil
    render :single
  end
  
  def create
    @report_template = current_user.report_templates.build(params_for_report_template)
    if @report_template.save
      render json: { redirect_url: dashboard_path }, status: 200
    else
      render json: { messages: @report_template.errors.full_messages }, status: 406
    end
    
  end
  
  def edit
    @report_template_id = @report_template.id.to_s
    render :single
  end
  
  def update
    @report_template.organizations.clear
    if @report_template.update_attributes(params_for_report_template)
      render json: { redirect_url: dashboard_path }, status: 200
    else
      render json: { messages: @report_template.errors.full_messages }, status: 406
    end
  end
  
  def destroy
    if @report_template.delete
      render json: { messages: ["Successfully deleted report template: '#{@report_template.name}'."]}, status: 200
    else
      render json: { messages: @report_template.errors.full_messages }, status: 406
    end
  end
  
  def view
    render json: @report_template, status: 200, serializer: FullReportTemplateSerializer
  end
  
  protected
  
  def get_title(action)
    "#{super} :: Report Templates"
  end
  
  private
  
  def params_for_report_template
    params.require(:report_template).permit(:name, :description, :content, :client).tap do |whitelist|
      whitelist[:organization_ids] = params[:report_template][:organization_ids]
    end
  end
  
  def load_report_template
    @report_template = current_user.report_templates.find(params[:id])
  end
end
