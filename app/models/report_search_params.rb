class ReportSearchParams
  
  attr_accessor :tags, :report_type, :search_term, :page_number, :per_page, :current_user
  
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 10
  
  def initialize(user, comma_delimited_tags, report_type, search_term, page, per_page)
    
    @current_user = user
    
    if comma_delimited_tags.present?
      @tags = comma_delimited_tags.strip.split(',')
    end
    
    if report_type.present?
      @report_type = report_type.strip.sub(" ", "").underscore.to_sym
    else
      raise "A report type is required when searching reports."
    end
    
    if search_term.present?
      @search_term = search_term.strip
    end
    
    if page.present?
      @page_number = page.strip.to_i
    else
      @page_number = DEFAULT_PAGE
    end
    
    if per_page.present?
      @per_page = per_page.strip.to_i
    else
      @per_page = DEFAULT_PER_PAGE
    end
  
  end
  
  def to_s
    "Tags: #{@tags.inspect}, User: #{@current_user.id}, Report Type: #{@report_type}, Search Term: #{@search_term}, Page: #{@page_number}, Per Page: #{@per_page}"
  end
  
end