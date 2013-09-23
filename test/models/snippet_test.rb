require "test_helper"

describe Snippet do
  before do
    @snippet = Snippet.new
  end

  it "must be valid" do
    @snippet.valid?.must_equal true
  end
end
