require "test_helper"

describe SearchResults::ReportSearchResults do
  
  def mock_result_set(opts={})
    options = {total_pages: 10, current_page: 5, limit_value: 10}.merge(opts)
    @reports = MiniTest::Mock.new
    @reports.expect(:total_pages, options[:total_pages])
    @reports.expect(:current_page, options[:current_page])
    @reports.expect(:limit_value, options[:limit_value])
  end
  
  it 'should know if it has next results' do
    mock_result_set
    result = SearchResults::ReportSearchResults.new(@reports)
    result.has_next?.must_equal true
  end
  
  it 'should know if it has no more results' do
    mock_result_set(current_page: 10)
    result = SearchResults::ReportSearchResults.new(@reports)
    result.has_next?.must_equal false
  end
  
  it 'should know if it has previous results' do
    mock_result_set
    result = SearchResults::ReportSearchResults.new(@reports)
    result.has_previous?.must_equal true
  end
  
  it 'should know if it has no previous results' do
    mock_result_set(current_page: 1)
    result = SearchResults::ReportSearchResults.new(@reports)
    result.has_previous?.must_equal false
  end
  
end