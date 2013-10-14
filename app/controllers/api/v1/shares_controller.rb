module Api
  module V1
    class SharesController < ApiController
      before_action :load_report, only: [:index, :update]
      before_action :load_share, only: [:update]
      before_action :load_user, only: [:by_associate]
      
      def index
        current_sharees = @report.get_shares(current_user)
        potential_sharees = current_user.get_associates.reject { |u| @report.shared_with?(u) }
        render json: Shares.new(current_sharees, potential_sharees), serializer: SharesSerializer
      end
  
      def update
        message = ""
        
        if @shared
          @report.share_with!(@user)
          current_user.notifications_initiated.create!(receiver: @user, message: "#{current_user.full_name} shared the report: '#{@report.name}' with you.")
          message = "Successfully shared the report with #{@user.full_name}."
        else
          @report.unshare_with!(@user)
                    current_user.notifications_initiated.create!(receiver: @user, message: "#{current_user.full_name} stopped sharing the report: '#{@report.name}' with you.")
          message = "Successfully stopped sharing the report with #{@user.full_name}."
        end
        
        render json: { messages: [message] }, status: 200
      end
      
      def by_associate
        shared_reports = current_user.get_reports_shared_with(@user)
        render json: shared_reports, each_serializer: SimpleReportSerializer
      end
      
      private
      
      def params_for_share
        params.require(:share).permit(:user_id, :shared)
      end
      
      def load_user
        @user = User.find(params[:id]);
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