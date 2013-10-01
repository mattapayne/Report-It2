module Api
  module V1
    class SharesController < ApiController
      before_action :load_item
      
      def index
        current_sharees = @shareable.get_shares(current_user)
        potential_sharees = current_user.get_associates.reject { |u| @shareable.shared?(u) }
        render json: Shares.new(current_sharees, potential_sharees), serializer: SharesSerializer
      end
  
      def update
        user = User.find(params_for_share[:user_id])
        is_shared = params_for_share[:shared]
        message = ""
        
        if is_shared
          @shareable.share_with!(user)
          message = "Successfully started sharing."
        else
          @shareable.unshare_with!(user)
          message = "Successfully stopped sharing."
        end
        
        render json: { messages: [message] }, status: 200
      end
      
      private
      
      def params_for_share
        params.require(:share).permit(:user_id, :report_id, :shared)
      end
      
      def load_item
        type = params[:type]
        
        unless type.present?
          raise "Unable to determine type when looking up shares."
        end
        
        case type.to_sym
          when :report
            @shareable = Report.find(params[:id]) if params[:id]
          when :report_template
            @shareable = ReportTemplate.find(params[:id]) if params[:id]
        end
        
        unless @shareable.present?
          render_not_found_json_response("Unable to locate that item.") and return
        end
        unless @shareable.owned_by_or_shared_with?(current_user)
          render_not_allowed_json_response("You are not allowed to access this item.") and return
        end
      end
    end
  end
end