class ReportsController < ApplicationController
  before_action :require_login
  before_action :load_report, only: [:update, :destroy, :edit]
  
  def index
    #ajax only
  end
  
  def new
    @report = current_user.reports.new
    render template: :single
  end
  
  def create
    #ajax only
  end
  
  def update
    #ajax only
  end
  
  def destroy
    #ajax only
  end
  
  def edit
    render template: :single
  end
  
  protected
  
  def get_title(action)
    "#{super} :: Reports"
  end
  
  private
  
  def load_report
    @report = Report.find(params[:id])
  end
  
end
