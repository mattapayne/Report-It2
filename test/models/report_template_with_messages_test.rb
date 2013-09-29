require "test_helper"

describe ReportTemplateWithMessages do
  before do
    @report_template_with_messages = ReportTemplateWithMessages.new
  end

  it "must be valid" do
    @report_template_with_messages.valid?.must_equal true
  end
end
