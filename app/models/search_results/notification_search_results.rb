class SearchResults::NotificationSearchResults
  include ActiveModel::Model
  include ActiveModel::SerializerSupport
  include SearchResults::BaseSearchResults
  
  def initialize(notifications)
    setup(notifications)
  end
end