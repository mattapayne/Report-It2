module Api
  class ApiController < ApplicationController
    respond_to :json
    before_action :require_login
  end
end