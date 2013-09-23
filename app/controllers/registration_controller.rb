class RegistrationController < ApplicationController
  
  before_action :require_logout
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params_for_registration)
    if @user.save
      UserMailer.activate_account_email(@user).deliver
      render json: { message: "Thank-you. You should receive an email shortly asking you to verify your account." }, status: 200
    else
      #TODO - change the way that the error messages are sent back. Should be an array that the client side code can process.
      render json: { message: @user.errors.full_messages.join("<br />") }, status: 406
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
