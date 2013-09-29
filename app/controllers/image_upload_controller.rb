class ImageUploadController < ApplicationController
  before_action :require_login
  skip_before_action :verify_authenticity_token, only: [:create]
  
  def create
    @img = RedactorImage.new(current_user)
    @img.image = params[:file]
    @img.image.store!
    render json: { filelink: @img.image.url }
  end
  
end
