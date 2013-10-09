class SearchResults::AssociateSearchResults
  include ActiveModel::Model
  include ActiveModel::SerializerSupport
  include SearchResults::BaseSearchResults
  
  def initialize(associates)
    setup(associates)
  end

end