require "test_helper"

describe ReportTemplate do
  before do
    @report_template = ReportTemplate.new
  end

  it "must be valid" do
    @report_template.valid?.must_equal true
  end
end
