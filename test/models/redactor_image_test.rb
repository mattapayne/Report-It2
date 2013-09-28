require "test_helper"

describe RedactorImage do
  before do
    @redactor_image = RedactorImage.new
  end

  it "must be valid" do
    @redactor_image.valid?.must_equal true
  end
end
