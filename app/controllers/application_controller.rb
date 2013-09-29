class ApplicationController < ActionController::Base
  include ApplicationHelper
  
  serialization_scope :current_user
  
  add_flash_types :error, :info, :warning, :success
  
  protect_from_forgery
  
  helper_method :current_user, :logged_in?
  
  before_action :set_common_variables
  
  helper_method :current_user, :logged_in?
  
  protected
  
  def default_serializer_options
    { root: false }
  end
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def verified_request?
    super || form_authenticity_token == request.headers['X_XSRF_TOKEN']
  end
  
  def login(id)
    session[:user_id] = id
  end
  
  def logout
    session[:user_id] = nil
  end
  
  def require_login
    unless logged_in?
      unless ajax_request?
        redirect_to root_path, error: "Please log in first"
      else
        render_not_logged_in_ajax_response
      end
    end
  end
  
  def require_logout
    if logged_in?
      redirect_to dashboard_path
    end
  end
  
  #this can/should be overridden in controllers inheriting from this
  def get_title(action)
    "Report It!"
  end
    
  def ajax_request?
    request.xhr?
  end
  
  private
  
  def set_common_variables
    @active_page = "#{params[:controller]}/#{params[:action]}"
    @page_title = get_title(params[:action])
  end
  
  #common response when an action requested via AJAX is not authorized.
  def render_not_logged_in_ajax_response
    render json: { redirect: root_path }, status: 401
  end
    
end
