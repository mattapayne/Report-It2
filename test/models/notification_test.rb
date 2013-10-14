require "test_helper"

describe Notification do
  before do
    @notification = Notification.new
  end

  it "must be valid" do
    @notification.valid?.must_equal true
  end
end
