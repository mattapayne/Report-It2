module Api
  module V1
    class UserTagsController < ApiController
      before_action :load_tags_by_type
      
      def index
        filter = params_for_filter
        filtered_tags = filter.nil? ? @tags : @tags.select { |t| t.include?(filter) }
        filtered_tags = filtered_tags.uniq
        render json: filtered_tags
      end

      private
      
      def params_for_filter
        return params.require(:query) if params[:query].present?
        return nil
      end
      
      def load_tags_by_type
        @tags = []
        tag_type = params[:type]
        if tag_type.present?
          case tag_type.to_s.singularize.downcase.to_sym
            when :report
              @tags = current_user.report_tags
            when :template
              @tags = current_user.template_tags
            else
          end
        end
      end
    end
  end     
end
  