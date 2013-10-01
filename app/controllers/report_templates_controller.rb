class ReportTemplatesController < ApplicationController
  before_action :require_login
  before_action :load_report_template, only: [:edit]
  
  def new
    
  end
  
  def edit
    
  end
  
  protected
  
  def get_title(action)
    "#{super} :: Report Templates"
  end
  
  private
  
  def load_report_template
    @report_template = ReportTemplate.find(params[:id])
    unless @report_template.present?
      redirect_to dashboard_path, error: "Unable to locate that report template." and return
    end
    unless @report_template.owned_by_or_shared_with?(current_user)
      redirect_to dashboard_path, error: "You do not have access that report template." and return
    end
    @report_template_id = @report_template.id
  end
end
