class ReportsController < ApplicationController
  before_action :require_login
  before_action :load_report, only: [:update, :destroy, :edit]
  
  def index
    render json: current_user.my_reports.to_a, status: 200
  end
  
  def new
    @report = current_user.my_reports.build
    render template: :single
  end
  
  def create
    @report = current_user.my_reports.build
    render template: :single
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
    @report = current_user.my_reports.find(params[:id])
  end
  
end
