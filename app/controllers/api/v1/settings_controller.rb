module Api
   module V1
    class SettingsController < ApiController
      before_action :load_setting, only: [:update]
      
      def index
        render json: current_user.settings.to_a
      end
      
      def update
        if @setting.update_attributes(params_for_setting)
          render json: { messages: ["Successfully updated setting: #{@setting.key}"] }
        else
          render json: { messages: @setting.errors.full_messages.to_a }, status: 406
        end
      end
      
      private
      
      def load_setting
        @setting = current_user.settings.find(params[:id])
        unless @setting.present?
          render_not_found_json_response("Unable to locate that setting.") and return
        end
      end
      
      def params_for_setting
        params.require(:setting).permit(:value)
      end
    end
  end
end
