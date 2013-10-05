module Api
  module V1
    class SnippetsController < ApiController
      before_action :load_snippet, only: [:update, :destroy]
      
      def index
        render json: current_user.snippets
      end
      
      def create
        snippet = current_user.snippets.build(params_for_snippet)
        if snippet.save
          render json: { messages: ["Successfully create the snippet: #{snippet.name}"], snippet: snippet }
        else
          render json: { messages: snippet.errors.full_messages.to_a }, status: 406
        end
      end
      
      def update
        if @snippet.update_attributes(params_for_snippet)
          render json: { messages: ["Successfully updated the snippet: #{@snippet.name}"] }
        else
          render json: { messages: @snippet.errors.full_messages.to_a }, status: 406
        end
      end
      
      def destroy
        if @snippet.destroy
          render json: { messages: ["Successfully deleted the snippet: #{@snippet.name}"] }
        else
          render json: { messages: @snippet.errors.full_messages.to_a }, status: 406
        end
      end
    
      private
      
      def params_for_snippet
        params.require(:snippet).permit(:name, :content)
      end
      
      def load_snippet
        @snippet = current_user.snippets.find(params[:id])
        unless @snippet.present?
          render_not_found_json_response("Unable to locate that snippet.") and return
        end
      end
    end
  end
end
