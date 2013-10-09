require "test_helper"

describe SearchParams::ReportSearchParams do
  
  let(:user) {User.new}
      
  it 'should process tags as an array if present' do
    search = SearchParams::ReportSearchParams.new({user: user, tags: ['a', 'b', 'c'], status: :draft, report_type: :report})
    search.tags.must_contain_all ['a', 'b', 'c']
  end
  
  it 'should correctly detect report type, regardless of plurality or case' do
    search = SearchParams::ReportSearchParams.new({user: user, tags: ['a', 'b', 'c'], status: :draft, report_type: "Reports"})
    search.report_type.must_equal :report
  end
  
  it 'should correctly detect status, regardless of plurality or case' do
    search = SearchParams::ReportSearchParams.new({user: user, tags: ['a', 'b', 'c'], status: "Drafts", report_type: :report})
    search.status.must_equal :draft
  end
  
  it 'should raise an exception if no user is specified' do
    proc { search = SearchParams::ReportSearchParams.new({tags: ['a'], status: :draft, report_type: :report})}.must_raise RuntimeError
  end
  
  it "should default to page #{SearchParams::ReportSearchParams::DEFAULT_PAGE} if no page is specified" do
    search = SearchParams::ReportSearchParams.new({user: user, tags: ['a'], status: :draft, report_type: :report})
    search.page_number.must_equal SearchParams::ReportSearchParams::DEFAULT_PAGE
  end
  
  it "should use the supplied page value if present" do
    search = SearchParams::ReportSearchParams.new({user: user, tags: ['a'], status: :draft, report_type: :report, page_number: 10})
    search.page_number.must_equal 10  
  end
  
  it "should default to #{SearchParams::ReportSearchParams::DEFAULT_PER_PAGE} per page if per_page is not specified" do
    search = SearchParams::ReportSearchParams.new({user: user, tags: ['a'], status: :draft, report_type: :report, page_number: 10})
    search.per_page.must_equal SearchParams::ReportSearchParams::DEFAULT_PER_PAGE  
  end 
  
  it 'should default to an empty string if no search term is specified' do
    search = SearchParams::ReportSearchParams.new({user: user, tags: ['a'], status: :draft, report_type: :report})
    search.search_term.must_be_empty
  end
  
  it 'should allow status to be unspecified' do
    search = SearchParams::ReportSearchParams.new({user: user, tags: ['a'], report_type: :report})
    search.status.must_be_nil
  end
  
  it 'should raise an exception when an invalid report type is supplied' do
     proc { search = SearchParams::ReportSearchParams.new({user: user, tags: ['a'], report_type: :monkey, status: :draft})}.must_raise RuntimeError
  end
  
  it 'should raise an exception when an invalid status is supplied' do
     proc { search = SearchParams::ReportSearchParams.new({user: user, tags: ['a'], report_type: :report, status: :monkey})}.must_raise RuntimeError
  end
  
  it 'should raise an exception if no report type is specified' do
    proc { search = SearchParams::ReportSearchParams.new({user: user, tags: ['a'], status: :draft})}.must_raise RuntimeError
  end
  
  it 'should default to an empty array if no tags are supplied' do
    search = SearchParams::ReportSearchParams.new({user: user, status: :draft, report_type: :report})
    search.tags.must_be_instance_of Array
  end
  
  it 'should convert a comma-delimited string of tags to an array' do
    search = SearchParams::ReportSearchParams.new({user: user, tags: 'a, b, c', status: :draft, report_type: :report})
    search.tags.must_contain_all ['a', 'b', 'c']
  end
  
end