require "test_helper"

describe SharedReportTemplate do
  
  def shared_report_template_properties
    { report_template: ReportTemplate.new, shared_by: User.new, shared_with: User.new }
  end
  
  let(:srt) { SharedReportTemplate.new(shared_report_template_properties) }

  it "is valid if all properties are present" do
    srt.valid?.must_equal true
  end
  
  it 'is invalid if report template is not set' do
    srt.report_template = nil
    srt.valid?.must_equal false
  end
  
  it 'is invalid if shared_by is not set' do
    srt.shared_by = nil
    srt.valid?.must_equal false
  end
  
  it 'is invalid if shared_with is not set' do
    srt.shared_with = nil
    srt.valid?.must_equal false
  end
  
end
