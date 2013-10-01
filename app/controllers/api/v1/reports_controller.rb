module Api
  module V1
    class ReportsController < ApiController
      before_action :load_report, only: [:update, :destroy, :edit]
      before_action :construct_tag_filter, only: [:index]
      
      def index
        tag_filter  = params_for_report_filters.split(',') unless params_for_report_filters.nil?
        case tag_filter
          when nil
            reports = []
          when ['all'] #Ugh!
            reports = current_user.all_reports
          else
            reports = current_user.all_reports(tag_filter)
        end
        render json: reports.to_a
      end
  
      def create
        report = Report.create(params_for_report.merge(creator: current_user))
        if report.save
          result = ReportWithMessages.new(['Successfully created the report.'], report)
          render json: result, serializer: ReportWithMessagesSerializer
        else
          render json: { messages: report.errors.full_messages }, status: 406
        end
      end
  
      def update
        if @report.update_attributes(params_for_report)
          result = ReportWithMessages.new(['Successfully updated the report.'], @report)
          render json: result, serializer: ReportWithMessagesSerializer
        else
          render json: { messages: @report.errors.full_messages }, status: 406
        end
      end
  
      def destroy
        if @report.destroy
          render json: { messages: ["Successfully deleted report: '#{@report.name}'."]}
        else
          render json: { messages: @report.errors.full_messages }, status: 406
        end
      end
      
      def new
        report = Report.new(creator: current_user)
        render json: report, serializer: FullReportSerializer
      end
  
      def edit
        render json: @report, serializer: FullReportSerializer
      end
      
      private
  
      def construct_tag_filter
        unless params_for_report_filters.nil?
          @tag_filter = params_for_report_filters.split(',')
        end
      end
      
      def params_for_report_filters
        return params.require(:tags) if params[:tags].present?
      end
      
      def params_for_report
        params.require(:report).permit(:name, :description, :content, :report_template_id, tags: [])
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
