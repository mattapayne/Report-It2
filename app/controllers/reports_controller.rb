class ReportsController < ApplicationController
  before_action :require_login
  before_action :load_report, only: [:edit]
  
  def edit

  end
  
  def new
    
  end
  
  protected
  
  def get_title(action)
    "#{super} :: Reports"
  end
  
  private
  
  def load_report
    @report = Report.find(params[:id]) if params[:id]
    unless @report.present?
      redirect_to dashboard_path, error: "Unable to locate that report." and return
    end
    unless @report.owned_by_or_shared_with?(current_user)
      redirect_to dashboard_path, error: "You do not have access that report." and return
    end
    @report_id = @report.id
  end
  
end
