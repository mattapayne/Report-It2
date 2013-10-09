class SearchResults::InvitationSearchResults
  include ActiveModel::Model
  include ActiveModel::SerializerSupport 
  include SearchResults::BaseSearchResults
  
  def initialize(invitations)
    setup(invitations)
  end
end