require "test_helper"

describe ReportWithMessages do
  before do
    @report_with_messages = ReportWithMessages.new
  end

  it "must be valid" do
    @report_with_messages.valid?.must_equal true
  end
end
