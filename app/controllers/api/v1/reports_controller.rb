module Api
  module V1
    class ReportsController < ApiController
      before_action :load_report, only: [:update, :destroy, :edit, :copy]
      before_action :construct_search_params, only: [:index]
      
      def index
        results = SearchResults::ReportSearchResults.new(Report.search(@search))
        render json: results, serializer: PagedReportsSerializer
      end
  
      def create
        report = Report.new(params_for_report.merge(creator: current_user))
        if report.save
          result = ReportWithMessages.new(['Successfully created the report.'], report)
          render json: result, serializer: ReportWithMessagesSerializer
        else
          render json: { messages: report.errors.full_messages }, status: 406
        end
      end
  
      def update
        if @report.update_attributes(params_for_report.merge(last_edited_by: current_user))
          @report.save
          unless @report.owner?(current_user)
            current_user.notifications_initiated.create!(receiver: @report.creator, message: "#{current_user.full_name} edited your report: '#{@report.name}'.")
          end
          result = ReportWithMessages.new(['Successfully updated the report.'], @report)
          render json: result, serializer: ReportWithMessagesSerializer
        else
          render json: { messages: @report.errors.full_messages }, status: 406
        end
      end
  
      def destroy
        unless @report.owner?(current_user)
          render_not_allowed_json_response("You are not permitted to delete that report.") and return
        end
        
        if @report.destroy
          render json: { messages: ["Successfully deleted report: '#{@report.name}'."]}
        else
          render json: { messages: @report.errors.full_messages }, status: 406
        end
      end
      
      def new
        type = params[:type]
        report = Report.new(creator: current_user, report_type: type)
        render json: report, serializer: FullReportSerializer
      end
  
      def edit
        render json: @report, serializer: FullReportSerializer
      end
      
      def copy
        new_report = Report.copy(current_user, @report)
        render json: new_report, serializer: FullReportSerializer
      end
      
      private
      
      def construct_search_params
        @search = SearchParams::ReportSearchParams.new(params.dup.merge(user: current_user))
      end
      
      def params_for_report
        params.require(:report).permit(:name, :description, :content, :report_type, :status, :header, :footer, tags: [])
      end
      
      def load_report
        @report = Report.find(params[:id]) if params[:id]
        unless @report.present?
          render_not_found_json_response("Unable to locate that report.") and return
        end
        unless @report.owned_by_or_shared_with?(current_user)
          render_not_allowed_json_response("You do not have access to that report.") and return
        end
      end
    end
  end
end
