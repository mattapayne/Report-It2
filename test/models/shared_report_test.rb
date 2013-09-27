require "test_helper"

describe SharedReport do
  
  def shared_report_properties
    { report: Report.new, shared_by: User.new, shared_with: User.new }
  end
  
  let(:sr) { SharedReport.new(shared_report_properties) }

  it "is valid if all properties are present" do
    sr.valid?.must_equal true
  end
  
  it 'is invalid if report is not set' do
    sr.report = nil
    sr.valid?.must_equal false
  end
  
  it 'is invalid if shared_by is not set' do
    sr.shared_by = nil
    sr.valid?.must_equal false
  end
  
  it 'is invalid if shared_with is not set' do
    sr.shared_with = nil
    sr.valid?.must_equal false
  end
  
end