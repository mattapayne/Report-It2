class ReportTemplatesController < ApplicationController
  before_action :require_login
  before_action :load_report_template, only: [:update, :destroy, :edit]
  
  def index
    #ajax only
  end
  
  def new
    @report_template = current_user.reports_templates.new
    render template: :single
  end
  
  def create
    #ajax only
  end
  
  def edit
    render template: :single
  end
  
  def update
    #ajax only
  end
  
  def destroy
    #ajax only
  end
  
  protected
  
  def get_title(action)
    "#{super} :: Report Templates"
  end
  
  private
  
  def load_report_template
    @report_template = ReportTemplate.find(params[:id])
  end
end
