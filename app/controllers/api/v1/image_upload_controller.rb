module Api
  module V1
    class ImageUploadController < ApiController
      skip_before_action :verify_authenticity_token, only: [:create]
      before_action :ensure_file_present, only: [:create]
    
      def create
        img = RedactorImage.new(current_user)
        img.image = params[:file]
        img.image.store!
        render json: { filelink: img.image.url }
      end
      
      private
      
      def ensure_file_present
        unless params[:file].present?
          raise "No uploaded file is present"
        end
      end
    end  
  end
end
