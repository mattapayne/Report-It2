require "test_helper"

def all_user_props
  { first_name: "First", last_name: "Last", email: "test@example.com", password: "password", password_confirmation: "password" }
end

describe User do
  
  let(:empty_user) { User.new }
  let(:complete_user) { User.new(all_user_props)}
  
  describe 'Authentication' do
    
    it 'should authenticate the correct password and return the user' do
      complete_user.authenticate('password').must_equal complete_user
    end
    
    it 'should NOT authenticate the wrong password' do
      complete_user.authenticate('test').must_equal false
    end
    
  end
  
  describe 'Before save' do
    
    it 'should set the signup token' do
      complete_user.signup_token.must_be_nil
      complete_user.save!
      complete_user.signup_token.wont_be_nil
    end
    
    it 'should add default UserSettings' do
      complete_user.settings.must_be_empty
      complete_user.save!
      complete_user.settings.wont_be_empty
    end
    
  end
  
  describe 'Associations between users' do
    
    let(:user_a) { User.new({first_name: 'Matt', last_name: 'Payne', email: 'test@test.ca', password: '232423', password_confirmation: '232423' }) }
    let(:user_b) { User.new({first_name: 'Other', last_name: 'Other', email: 'other@test.ca', password: '232423', password_confirmation: '232423' })}
  
    it 'should associate users such that each is an associate of the other' do
      user_a.save!
      user_b.save!
      
      user_a.associate_with!(user_b)
      
      user_a.associated_with?(user_b).must_equal true
      user_b.associated_with?(user_a).must_equal true
    end
    
    it 'should disassociate users such that each is no longer an associate of the other' do
      user_a.save!
      user_b.save!
      
      user_a.associate_with!(user_b)
      
      user_a.associated_with?(user_b).must_equal true
      user_b.associated_with?(user_a).must_equal true
      
      user_b.disassociate_with!(user_a)
      
      user_a.associated_with?(user_b).must_equal false
      user_b.associated_with?(user_a).must_equal false
    end
    
    it 'should have associates if some have been added' do
      user_a.save!
      user_b.save!
      
      user_a.associates.must_be_empty
      user_b.associates.must_be_empty
      
      user_a.associate_with!(user_b)
      
      user_a.associates.wont_be_empty
      user_b.associates.wont_be_empty
    end
    
    it 'should handle multiple attempts at the same association gracefully when attempting the same association' do
      user_a.save!
      user_b.save!
      
      user_a.associate_with!(user_b)
      
      user_a.associates.count.must_equal 1
      user_b.associates.count.must_equal 1
      
      user_a.associate_with!(user_b)
      
      user_a.associates.count.must_equal 1
      user_b.associates.count.must_equal 1
    end
    
    it 'should handle multiple attempts at the same association gracefully when attempting the inverse association' do
      user_a.save!
      user_b.save!
      
      #a associates with b
      user_a.associate_with!(user_b)
      
      #each is associated to the other
      user_a.associates.count.must_equal 1
      user_b.associates.count.must_equal 1
      
      #user b associates with a
      user_b.associate_with!(user_a)
      
      #each is still associated with the other
      user_a.associates.count.must_equal 1
      user_b.associates.count.must_equal 1
    end
    
  end
    
  describe 'Validation' do
    
    it 'is invalid when initialized with no properies' do
      empty_user.valid?.must_equal false
    end
    
    it 'is invalid when email is not present' do
      complete_user.email = nil
      complete_user.valid?.must_equal false
    end
    
    it 'is invalid when email is not valid' do
      complete_user.email = 'not an email'
      complete_user.valid?.must_equal false
    end
    
    it 'is invalid when first_name is not present' do
      complete_user.first_name = nil
      complete_user.valid?.must_equal false
    end
    
    it 'is invalid when last_name is not present' do
      complete_user.last_name = nil
      complete_user.valid?.must_equal false
    end
    
    it 'should have password_digest set if password is set' do
      complete_user.password_digest.wont_be_nil
    end
    
    it 'is invalid if password length is less than minimum' do
      complete_user.password = '12345'
      complete_user.valid?.must_equal false
    end
    
  end
  
end