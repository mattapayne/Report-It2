module Api
  module V1
    class AssociatesController < ApiController
      skip_before_action :require_api_key, only: [:potentials]
      before_action :construct_search_params, only: [:index]
      before_action :construct_filter_query, only: [:potentials]
      
      def index
        result = SearchResults::AssociateSearchResults.new(current_user.get_associates(@search))
        render json: result, serializer: PagedAssociatesSerializer
      end
      
      def potentials
        potential_associates = current_user.get_potential_associates(@filter)
        render json: potential_associates.map(&:email).uniq
      end
      
      def destroy
        user = User.find(params[:id])
        current_user.disassociate_with!(user)
        render json: { messages: ["Successfully disassociated with #{user.full_name}."] }
      end
      
      private
      
      def construct_filter_query
        @filter = params[:q]
      end
      
      def construct_search_params
        @search = SearchParams::AssociateSearchParams.new(params.dup)
      end
  
    end
  end
end