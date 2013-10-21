module Api
  module V1
    class AssociatesController < ApiController
      before_action :construct_search_params, only: [:index]
      before_action :construct_filter_query, only: [:potentials]
      before_action :load_associate, only: [:destroy]
      
      def index
        result = SearchResults::AssociateSearchResults.new(current_user.get_associates(@search))
        render json: result, serializer: PagedAssociatesSerializer
      end
      
      def potentials
        potential_associates = current_user.get_potential_associates(@filter)
        render json: potential_associates.map(&:email).uniq
      end
      
      def destroy
        current_user.disassociate_with!(@associate)
        render json: { messages: ["Successfully disassociated with #{@associate.full_name}."] }
      end
      
      private
      
      def load_associate
        @associate = User.find(params[:id])
        unless current_user.associated_with?(@associate)
          render_error_json_response "Unable to disassociated with #{@associate.full_name} because no association exists." and return
        end
      end
      
      def construct_filter_query
        @filter = params[:q]
      end
      
      def construct_search_params
        @search = SearchParams::AssociateSearchParams.new(params.dup)
      end
  
    end
  end
end