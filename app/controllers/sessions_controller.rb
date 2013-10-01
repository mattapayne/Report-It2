class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      if user.must_validate_account?
        render json: { messages: ["You have not yet validated your account. Please do so before logging in."] }, status: 401
      else     
        login(user.id)
        render json: { redirect: dashboard_path }
      end
    else
      render json: { messages: ["Invalid username or password."] }, status: 401
    end
  end
  
  def destroy
    logout
    redirect_to root_path, success: 'You have been logged out. Goodbye!'
  end
end
