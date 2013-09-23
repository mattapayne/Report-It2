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