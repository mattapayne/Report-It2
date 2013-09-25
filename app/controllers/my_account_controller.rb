class MyAccountController < ApplicationController
  
  before_action :require_login
  
  def index
    
  end
  
  protected
  
  def get_title(action)
    "#{super} :: My Account"
  end
  
end
