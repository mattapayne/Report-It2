class SettingsController < ApplicationController
  before_action :require_login

  def index
    render json: current_user.settings.to_a, status: 200
  end
  
  def update
    @setting = current_user.settings.find(params[:id])
    if @setting.update_attributes(params_for_setting)
      render json: { messages: ["Successfully updated setting: #{@setting.key}"] }, status: 200
    else
      render json: { messages: @setting.errors.full_messages.to_a }, status: 406
    end
    
  end
  
  private
  
  def params_for_setting
    params.require(:setting).permit(:value)
  end
  
end
