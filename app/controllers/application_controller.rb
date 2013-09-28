class ApplicationController < ActionController::Base
  include ApplicationHelper
  
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
    unless @current_user.nil?
      return @current_user
    end
    #Could not connect to a primary node for replica set #<Moped::Cluster:70335573022940 @seeds=[<Moped::Node resolved_address="127.0.0.1:27017">]>
    #MOPED: Retrying connection attempt 1 more time(s). runtime: n/a
    timedout = false
    count = 0
    begin
      begin
        @current_user = User.find(session[:user_id]) if session[:user_id]
        timedout = false
      rescue Timeout::Error => e
        timedout = true
        count = count + 1
        puts "&&&&&&&&& Mongo connection timed out #{count} time. &&&&&&&&&&"
        puts "Exception: #{e}"
      end
    end while(timedout == true && count <= 3)
    
    @current_user
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
        redirect_to root_url, error: "Please log in first"
      else
        render_not_logged_in_ajax_response
      end
    end
  end
  
  def require_logout
    if logged_in?
      redirect_to dashboard_url
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
    render json: { redirect: root_url }, status: 401
  end
    
end
