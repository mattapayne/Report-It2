module SearchResults::BaseSearchResults
  
  attr_accessor :items, :total_pages, :current_page, :per_page
  
  def has_next?
    @current_page < @total_pages
  end
  
  def has_previous?
    @current_page > 1
  end
  
  protected
  
  def setup(items)
    @items = items
    @total_pages = @items.total_pages
    @current_page = @items.current_page
    @per_page = @items.limit_value
  end
end
