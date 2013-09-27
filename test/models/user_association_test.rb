require "test_helper"

describe UserAssociation do
  
  def user_association_properties
    { user: User.new, associate: User.new }
  end
  
  let(:ua) { UserAssociation.new(user_association_properties) }

  it "is valid if all properties are present" do
    ua.valid?.must_equal true
  end
  
  it 'is invalid if user is not set' do
    ua.user = nil
    ua.valid?.must_equal false
  end
  
  it 'is invalid if associate is not set' do
    ua.associate = nil
    ua.valid?.must_equal false
  end
  
end