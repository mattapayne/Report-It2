require "test_helper"

describe PasswordResetRequest do
  
  def all_props
    { email: "test@example.com", password: "password", password_confirmation: "password" }
  end
  
  let(:prr) { PasswordResetRequest.new(all_props)}

  it "must be valid" do
    prr.valid?.must_equal true
  end
end
