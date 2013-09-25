class OrganizationsController < ApplicationController
  before_action :require_login
  before_action :load_organization, only: [:update, :destroy]
  
  def index
    render json: current_user.organizations.to_a, status: 200
  end
  
  def create
    @organization = current_user.organizations.build(params_for_organization)
    if @organization.save
      render json: { messages: ["Successfully create the organization: #{@organization.name}"], organization: @organization }, status: 200
    else
      render json: { messages: @organization.errors.full_messages.to_a }, status: 406
    end
  end
  
  def update
    if @organization
      if @organization.update_attributes(params_for_organization)
        render json: { messages: ["Successfully updated the organization: #{@organization.name}"] }, status: 200
      else
        render json: { messages: @organization.errors.full_messages.to_a }, status: 406
      end
    else
      render json: { messages: ['Unable to find that organization.'] }, status: 404
    end
  end
  
  def destroy
    if @organization
      if @organization.delete
        render json: { messages: ["Successfully deleted the organization: #{@organization.name}"] }, status: 200
      else
        render json: { messages: @organization.errors.full_messages.to_a }, status: 406
      end
    else
      render json: { messages: ['Unable to find that organization.'] }, status: 404
    end
  end
  
  private
  
  def load_organization
    @organization = current_user.organizations.find(params[:id])
  end
  
  def params_for_organization
    params.require(:organization).permit(:name)
  end
end
