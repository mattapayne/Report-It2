module Api
  module V1
    class ReportTemplatesController < ApiController
      before_action :load_report_template, only: [:update, :destroy, :edit]
      before_action :construct_tag_filter, only: [:index]
      
      def index
        case @tag_filter
          when nil
            reports = []
          when ['all'] #Ugh!
            reports = current_user.all_templates
          else
            reports = current_user.all_templates(@tag_filter)
        end
        render json: reports.to_a
      end
      
      def create
        report_template = ReportTemplate.create(params_for_report_template.merge(creator: current_user))
        if report_template.save
          result = ReportTemplateWithMessages.new(['Successfully created the report template.'], report_template)
          render json: result, serializer: ReportTemplateWithMessagesSerializer
        else
          render json: { messages: report_template.errors.full_messages }, status: 406
        end
      end
  
      def update
        if @report_template.update_attributes(params_for_report_template)
          @result = ReportTemplateWithMessages.new(['Successfully updated the report template.'], @report_template)
          render json: @result, serializer: ReportTemplateWithMessagesSerializer
        else
          render json: { messages: @report_template.errors.full_messages }, status: 406
        end
      end
      
      def destroy
        if @report_template.destroy 
          render json: { messages: ["Successfully deleted report template: '#{@report_template.name}'."]}
        else
          render json: { messages: @report_template.errors.full_messages }, status: 406
        end
      end
      
      def new
        report_template = ReportTemplate.new(creator: current_user)
        render json: report_template, serializer: FullReportTemplateSerializer
      end
      
      def edit
        render json: @report_template, serializer: FullReportTemplateSerializer
      end
      
      private
  
      def construct_tag_filter
        unless params_for_report_template_filters.nil?
          @tag_filter = params_for_report_template_filters.split(',')
        end
      end
      
      def params_for_report_template_filters
        return params.require(:tags) if params[:tags].present?
      end
      
      def params_for_report_template
        params.require(:report_template).permit(:name, :description, :content, tags: [])
      end
      
      def load_report_template
        @report_template = ReportTemplate.find(params[:id])
        unless @report_template.present?
          render_not_found_json_response("Unable to locate that report template.") and return
        end
        unless @report_template.owned_by_or_shared_with?(current_user)
          render_not_allowed_json_response("You do not have access to that report.") and return
        end
      end
    end
  end
end