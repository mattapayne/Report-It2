require "test_helper"

describe PasswordResetRequest do
  
  def all_props
    { email: "test@example.com", password: "password", password_confirmation: "password" }
  end
  
  let(:prr) { PasswordResetRequest.new(all_props)}

  it "is valid if all properties are set and valid" do
    prr.valid?.must_equal true
  end
  
  it 'is invalid if email is not set and it is being created' do
    prr.email = nil
    proc { prr.save! }.must_raise Mongoid::Errors::Validations
  end
  
  it 'is invalid if email is not a valid email address' do
    prr.email = 'This is not an email!'
    proc { prr.save! }.must_raise Mongoid::Errors::Validations
  end
  
  it 'is invalid if password is not set' do
    prr.password = nil
    prr.valid?.must_equal false
  end
  
  it 'is invalid if password is too short' do
    prr.password = 'short'
    prr.valid?.must_equal false
  end
  
  it 'is invalid if password_confirmation does not match password' do
    prr.password_confirmation = 'abscred'
    prr.valid?.must_equal false
  end
  
  describe 'Token generation' do
    
    it 'will create a password reset token when created' do
      prr.reset_token.must_be_nil
      prr.save!
      prr.reset_token.wont_be_nil
    end
    
  end
  
  describe 'Password digest generation' do
    
    it 'will generate a password digest when created' do
      prr.password_digest.must_be_nil
      prr.save!
      prr.password_digest.wont_be_nil
    end
    
  end
end
