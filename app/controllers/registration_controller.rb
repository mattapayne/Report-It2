class RegistrationController < ApplicationController
  
  before_action :require_logout
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params_for_registration)
    if @user.save
      UserMailer.activate_account_email(@user).deliver
      render json: { messages: ["Thank-you. You should receive an email shortly asking you to verify your account."] }, status: 200
    else
      render json: { messages: @user.errors.full_messages.to_a }, status: 406
    end
  end
  
  protected
  
  def get_title(action)
    "#{super} :: Register"
  end
  
  private

  def params_for_registration
    params.require(:registration).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
  
end
