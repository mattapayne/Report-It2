require "test_helper"

describe RedactorImage do
  
  let(:user) { User.new }
  let(:image) { RedactorImage.new(user)}
  
  describe "Validation" do
    it "must be valid" do
      image.valid?.must_equal true
    end
  end
end
