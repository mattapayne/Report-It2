module Api
  module V1
    class SharesController < ApiController
      before_action :load_item
      
      def index
        current_sharees = @report.get_shares(current_user)
        potential_sharees = current_user.get_associates.reject { |u| @report.shared_with?(u) }
        render json: Shares.new(current_sharees, potential_sharees), serializer: SharesSerializer
      end
  
      def update
        user = User.find(params_for_share[:user_id])
        is_shared = params_for_share[:shared]
        message = ""
        
        if is_shared
          @report.share_with!(user)
          message = "Successfully shared the report with #{user.full_name}."
        else
          @report.unshare_with!(user)
          message = "Successfully stopped sharing the report with #{user.full_name}."
        end
        
        render json: { messages: [message] }, status: 200
      end
      
      private
      
      def params_for_share
        params.require(:share).permit(:user_id, :report_id, :shared)
      end
      
      def load_item
        @report = Report.find(params[:id]) if params[:id]
        unless @report.present?
          render_not_found_json_response("Unable to locate that item.") and return
        end
        unless @report.owned_by_or_shared_with?(current_user)
          render_not_allowed_json_response("You are not allowed to access this item.") and return
        end
      end
    end
  end
end