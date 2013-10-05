module Api
  module V1
    class SharesController < ApiController
      before_action :load_report
      before_action :load_share, only: [:update]
      
      def index
        current_sharees = @report.get_shares(current_user)
        potential_sharees = current_user.get_associates.reject { |u| @report.shared_with?(u) }
        render json: Shares.new(current_sharees, potential_sharees), serializer: SharesSerializer
      end
  
      def update
        message = ""
        
        if @isshared
          @report.share_with!(@user)
          message = "Successfully shared the report with #{@user.full_name}."
        else
          @report.unshare_with!(@user)
          message = "Successfully stopped sharing the report with #{@user.full_name}."
        end
        
        render json: { messages: [message] }, status: 200
      end
      
      private
      
      def params_for_share
        params.require(:share).permit(:user_id, :shared)
      end
      
      def load_share
        @user = User.find(params_for_share[:user_id])
        @shared = params_for_share[:shared] || false
        unless @user.present?
          render_not_found_json_response("Unable to locate that user.") and return
        end
        unless @user.associated_with?(current_user)
          render_not_allowed_json_response("You are not allowed to share this report.") and return
        end
      end
      
      def load_report
        @report = Report.find(params[:id]) if params[:id]
        unless @report.present?
          render_not_found_json_response("Unable to locate that report.") and return
        end
        unless @report.owned_by_or_shared_with?(current_user)
          render_not_allowed_json_response("You are not allowed to access this report.") and return
        end
      end
    end
  end
end