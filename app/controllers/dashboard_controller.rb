class DashboardController < ApplicationController
  before_action :require_login
  
  def index
    
  end
  
  protected
  
  def get_title(action)
    "#{super} :: Dashboard"
  end

end
