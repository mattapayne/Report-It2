class OrganizationsController < ApplicationController
  before_action :require_login
  before_action :load_organization, only: [:update, :destroy]
  
  def index
    #ajax only
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
  
  private
  
  def load_organization
    #load specific organization here
  end
end
