class SearchParams::NotificationSearchParams
  include SearchParams::BaseSearchParams
  
  def initialize(opts={})
    setup(opts)
  end
end