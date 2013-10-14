module Api
  module V1
    class MyAccountController < ApiController
      
      def update_password
        update = {
          password: params_for_password_update[:password],
          password_confirmation: params_for_password_update[:password_confirmation]
        }
        errors = validate_password_change(update)
        if errors.empty?
          if current_user.update_attributes(update)
            render json: { messages: ['Successfully updated your password.']}
          else
            render json: { messages: current_user.errors.full_messages }, status: 406
          end
        else
          render json: { messages: errors }, status: 406
        end
      end
      
      def my_profile_image
        render json: { url: current_user.profile_image_url }
      end
      
      private
      
      #TODO - Move this logic to the model
      def validate_password_change(update)
        errors = []
        unless update[:password].present?
          errors << "You must supply a new password."
          return errors
        end
        unless update[:password_confirmation].present?
          errors << "You must supply a password confirmation."
          return errors  
        end
        unless update[:password].length >= 6
          errors << "The password must be at least 6 characters."
          return errors
        end
        unless update[:password] == update[:password_confirmation]
          errors << "The password confirmation must match the password."
          return errors
        end
        errors
      end
      
      def params_for_password_update
        params.require(:update).permit(:password, :password_confirmation)
      end
    end
  end
end