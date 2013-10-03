class ReportSearchResults
  include ActiveModel::Model
  include ActiveModel::SerializerSupport 
  
  attr_accessor :reports, :total_pages, :current_page, :per_page
  
  def initialize(reports)
    @reports = reports
    @total_pages = @reports.total_pages
    @current_page = @reports.current_page
    @per_page = @reports.limit_value
  end

  def has_next?
    @current_page < @total_pages
  end
  
  def has_previous?
    @current_page > 1
  end
end