module Api
  module V1
    class ImageUploadController < ApiController
      skip_before_action :verify_authenticity_token, only: [:redactor_image, :my_profile_image]
      skip_before_action :require_api_key, only: [:redactor_image, :my_profile_image]
      before_action :ensure_file_present, only: [:redactor_image, :my_profile_image]
    
      def redactor_image
        img = RedactorImage.new(current_user)
        img.image = params[:file]
        img.image.store!
        render json: { filelink: img.image.url }
      end
      
      def my_profile_image
        img = MyProfileImage.new
        img.image = params[:file]
        img.image.store!
        current_user.profile_image_url = img.image.url
        if current_user.save
          render json: { messages: ['Successfully uploaded your profile image.']}
        else
          render json: { messages: current_user.errors.full_messages }, status: 406
        end
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
