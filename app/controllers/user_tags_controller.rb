class UserTagsController < ApplicationController
    before_action :require_login
    
    def index
      render json: current_user.tags.to_a
    end
    
    def update
      current_user.tags.clear
      tags = params_for_tags
      current_user.tags << tags unless tags.nil?
      if current_user.save
        render json: { messages: ['Successfully updated your tags,'] }
      else
        render json: { messages: current_user.error.full_messages.to_a }, status: 406
      end
      
    end
    
    private
    
  def params_for_tags
    return params.require(:tags) if params[:tags].present?
    return []
  end
end
