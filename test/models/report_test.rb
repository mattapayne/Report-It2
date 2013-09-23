require "test_helper"

describe Report do
  before do
    @report = Report.new
  end

  it "must be valid" do
    @report.valid?.must_equal true
  end
end
