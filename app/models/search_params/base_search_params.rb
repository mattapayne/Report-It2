module SearchParams::BaseSearchParams
  attr_accessor :per_page, :page_number
  
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 10
  DEFAULTS = {
    page_number: DEFAULT_PAGE,
    per_page: DEFAULT_PER_PAGE
  }.freeze
  
  protected
  
  def setup(opts={})
    
    options = DEFAULTS.merge(opts)
    
    options.symbolize_keys!
    
    @page_number = options[:page_number]
    
    if @page_number.present?
      @page_number = @page_number.to_s.strip.to_i
    else
      @page_number = DEFAULT_PAGE
    end
    
    @per_page = options[:per_page]
    
    if per_page.present?
      @per_page = per_page.to_s.strip.to_i
    else
      @per_page = DEFAULT_PER_PAGE
    end
    
  end
end


