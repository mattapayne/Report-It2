require "test_helper"

describe RedactorImage do
  
  let(:user) { User.new }
  let(:image) { RedactorImage.new(user)}
  
  describe "Validation" do
    it "must be valid" do
      image.valid?.must_equal true
    end
  end
  
  describe "Use of the image" do
    
    it 'should use the user specified height if present' do
      user.settings.build(key: 'image_height', value: 750)
      image.user_specific_height.must_equal 750
    end
    
    it 'should use the default height if user specified height not present' do
      image.user_specific_height.must_equal RedactorImage::DEFAULT_HEIGHT
    end
  
    it 'should use the user specified width if present' do
      user.settings.build(key: 'image_width', value: 750)
      image.user_specific_width.must_equal 750
    end
    
    it 'should use the default width if user specified width not present' do
      image.user_specific_width.must_equal RedactorImage::DEFAULT_WIDTH
    end
    
  end
end
