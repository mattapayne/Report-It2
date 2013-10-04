module Api
  class ApiController < ApplicationController
    respond_to :json
    before_action :require_login, :require_api_key
    
    private
    
    def require_api_key
      api_key = ENV['application_api_key']
      supplied_key = request.headers['X-Application-API-Key']
      unless supplied_key.present? && supplied_key == api_key
        render_not_logged_in_ajax_response
      end
    end
  end
end