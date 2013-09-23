require "test_helper"

describe Organization do
  before do
    @organization = Organization.new
  end

  it "must be valid" do
    @organization.valid?.must_equal true
  end
end
