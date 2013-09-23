class UserMailer < ActionMailer::Base
  default from: ENV['from_email'] #This is set in environment.yml
  
  def activate_account_email(user)
    @user = user
    @url = validate_account_url(@user.signup_token)
    mail(to: @user.email, subject: "Welcome to Report It!")
  end
  
  def password_reset_request_email(user, request)
    @user = user
    @url = password_reset_url(request.reset_token)
    mail(to: @user.email, subject: "Report It! Password Reset Request Confirmation")
  end
  
end
