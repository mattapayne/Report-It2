class SearchParams::ReportSearchParams
  include SearchParams::BaseSearchParams
  
  attr_accessor :tags, :report_type, :search_term, :current_user, :status, :all_in_tags
  
  REPORT_TYPES = [:report, :template].freeze
  STATUSES = [:draft, :published].freeze
  DEFAULTS = {
      user: nil,
      tags: [],
      all_in_tags: true,
      search_term: '',
    }.freeze
  
  def initialize(opts)
    
    options = DEFAULTS.merge(opts).symbolize_keys
    
    setup(options)
    
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
    
    if @status.present?    
      @status = @status.to_s.downcase.strip.singularize.to_sym
      unless STATUSES.include?(@status)
        raise "#{status} is not a valid report status."
      end
    end
    
    @all_in_tags = (options[:all_in_tags] || 'true').to_s.downcase == 'true' ? true : false
    
    @tags = options[:tags]
    
    unless @tags.is_a?(Array)
      @tags = @tags.to_s.strip.split(",").map { |s| s.strip }
    end
    
    @search_term = options[:search_term]
    
    if search_term.present?
      @search_term = search_term.strip
    end

  end
end