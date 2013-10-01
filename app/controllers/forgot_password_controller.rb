class ForgotPasswordController < ApplicationController
  
  before_action :require_logout
  
  def new
    @request = PasswordResetRequest.new
  end
  
  def create
    request = PasswordResetRequest.new(params_for_password_reset_request)
    if request.valid?
      user = User.find_by(email: @request.email)
      if user
        user.password_reset_requests << request
        if user.save
          UserMailer.password_reset_request_email(user, request).deliver
          render json: { messages: ["Thank-you. You will receive an email shortly asking you to verify your password reset request."] }
        else
          render json: { messages: user.errors.full_messages.to_a }, status: 406
        end
      else
        render json: { messages: ["Sorry, that username does not exist."]}, status: 406
      end
    else
      render json: { messages: ["Invalid request."]}, status: 406 #should never get here, but you never know.
    end
  end
  
  def reset
    request = PasswordResetRequest.find_by(reset_token: params[:token])
    if request
      user = request.creator
      user.password_digest = request.password_digest
      if user.save
        request.destroy
        redirect_to root_path, success: "Thank-you. Your password has been reset."
      else
        #TODO - error saving the user! Fix this to do something better
        redirect_to root_path, error: user.errors.full_messages
      end
    else
      redirect_to root_path, error: "Sorry, but no password reset request was made that corresponds to the supplied token."
    end
  end
  
  protected
  
  def get_title(action)
    "#{super} :: Forgot Password"
  end
  
  private
  
  def params_for_password_reset_request
    params.require(:password_reset_request).permit(:email, :password, :password_confirmation)
  end
end
