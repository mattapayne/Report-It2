require "test_helper"

describe AssociateInvitation do
  
  def associate_invitation_properties
    { inviter: User.new, invitee: User.new(email: 'test@example.com'), invitee_email: 'test@example.com', message: 'Please be my friend' }
  end
  
  let(:invite) { AssociateInvitation.new(associate_invitation_properties) }
  
  describe 'Validation' do
  
    it 'should be valid of all properties are set correctly' do
      invite.valid?.must_equal true  
    end
    
    it 'should be invalid if inviter not set' do
      invite.inviter = nil
      invite.valid?.must_equal false
    end
    
    it 'should be invalid if invitee not set' do
      invite.invitee = nil
      invite.valid?.must_equal false     
    end
    
  end
  
  describe 'Initial state' do
    
    it 'should be created with a state of pending' do
      invite.status.must_be_nil
      invite.save!
      invite.pending?.must_equal true
      invite.status.must_equal :pending
    end
    
  end
  
end
