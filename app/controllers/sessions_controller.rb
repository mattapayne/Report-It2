class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      if user.must_validate_account?
        #TODO - change the way that the error messages are sent back. Should be an array that the client side code can process.
        render json: { message: "You have not yet validated your account. Please do so before logging in." }, status: 401
      else     
        login(user.id)
        render json: { redirect: dashboard_path }
      end
    else
      #TODO - change the way that the error messages are sent back. Should be an array that the client side code can process.
      render json: { message: "Invalid username or password." }, status: 401
    end
  end
  
  def destroy
    logout
    redirect_to root_path, success: 'You have been logged out. Goodbye!'
  end
end
