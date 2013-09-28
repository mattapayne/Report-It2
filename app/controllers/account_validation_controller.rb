class AccountValidationController < ApplicationController
  def new
    @token = params_for_validation
    @user = User.find_by(signup_token: @token)
    if @user
      @user.signup_token = nil
      if @user.save
        login(@user.id)
        redirect_to dashboard_path, success: "Thank-you. Your account has now been validated and is ready for use."
      else
        redirect_to root_path, error: "Unable to validate your account. Please contact us to solve this problem."
      end
    end
  end
  
  private
  
  def params_for_validation(args)
    params.require(:token)
  end
end
