class SearchResults::ReportSearchResults
  include ActiveModel::Model
  include ActiveModel::SerializerSupport
  include SearchResults::BaseSearchResults
  
  def initialize(reports)
    setup(reports)
  end
end