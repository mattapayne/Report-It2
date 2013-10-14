module Api
  module V1  
    class NotificationsController < ApiController
      before_action :construct_search_params, only: [:index]
      
      def index
        notifications = current_user.get_unseen_notifications_received(@search)
        results = SearchResults::NotificationSearchResults.new(notifications)
        render json: results, serializer: PagedNotificationsSerializer
      end
      
      
      private
      
      def construct_search_params
        @search = SearchParams::AssociateSearchParams.new(params.dup)
      end
    end   
  end
end
