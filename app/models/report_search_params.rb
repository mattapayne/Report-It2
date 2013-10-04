class ReportSearchParams
  
  attr_accessor :tags, :report_type, :search_term, :page_number, :per_page, :current_user, :status
  
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 10
  REPORT_TYPES = [:report, :template].freeze
  STATUSES = [:draft, :published].freeze
  DEFAULTS = {
      user: nil,
      tags: [],
      search_term: '',
    }.freeze
  
  def initialize(opts)
  
    options = DEFAULTS.merge(opts).symbolize_keys
    
    @current_user = options[:user]
    
    unless @current_user.present?
      raise "A user must be supplied."
    end
    
    @report_type = options[:report_type]
    
    unless @report_type.present?
      raise "A report type must be supplied."
    else
      @report_type = @report_type.to_s.downcase.strip.singularize.to_sym
      unless REPORT_TYPES.include?(@report_type)
        raise "#{@report_type} is not a valid report type."
      end
    end
    
    @status = options[:status]
    
    unless @status.present?
      raise "A status must be supplied."
    else
      @status = @status.to_s.downcase.strip.singularize.to_sym
      unless STATUSES.include?(@status)
        raise "#{status} is not a valid report status."
      end
    end
    
    @tags = options[:tags]
    
    unless @tags.is_a?(Array)
      @tags = @tags.to_s.strip.split(",").map { |s| s.strip }
    end
    
    @search_term = options[:search_term]
    
    if search_term.present?
      @search_term = search_term.strip
    end
    
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
  
  def to_s
    "Tags: #{@tags.inspect}, User: #{@current_user.id}, Report Type: #{@report_type}, Search Term: #{@search_term}, Page: #{@page_number}, Per Page: #{@per_page}, Status: #{@status}"
  end
  
end