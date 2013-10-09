require "test_helper"

def all_user_props
  { first_name: "First", last_name: "Last", email: "test@example.com", password: "password", password_confirmation: "password" }
end

describe User do
  
  let(:empty_user) { User.new }
  let(:complete_user) { User.new(all_user_props)}
  let(:user_a) { User.new({first_name: 'Matt', last_name: 'Payne', email: 'test@test.ca', password: '232423', password_confirmation: '232423' }) }
  let(:user_b) { User.new({first_name: 'Other', last_name: 'Other', email: 'other@test.ca', password: '232423', password_confirmation: '232423' })}
  
  describe 'Authentication' do
    it 'should authenticate the correct password and return the user' do
      complete_user.authenticate('password').must_equal complete_user
    end
    
    it 'should NOT authenticate the wrong password' do
      complete_user.authenticate('test').must_equal false
    end
    
    it 'should know it needs to validate the account' do
      user_a.save!
      user_a.must_validate_account?.must_equal true
      user_a.account_validated!
      user_a.must_validate_account?.must_equal false
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
  
  describe 'Reports' do
    
    before :each do
      user_a.save!
      user_b.save!
    end
    
    it 'should not mix report tags and template tags' do
      r1 = Report.create!(name: "1", content: "xxx", creator: user_a, report_type: :report, tags: ['x', 'y'])
      rt2 = Report.create!(name: "2", content: "xfeee", creator: user_a, tags: ['1', '2'], report_type: :template)
      
      user_a.report_tags.must_contain_all ['x', 'y']
      user_a.template_tags.must_contain_none ['x', 'y']
      
      user_a.template_tags.must_contain_all ['1', '2']
      user_a.template_tags.must_contain_none ['x', 'y']
      
    end
    
    it 'should get all reports, both owned and shared with the user' do
      r1 = Report.create!(name: "1", content: "xxx", creator: user_a, report_type: :report)
      r2 = Report.create!(name: "2", content: "xfeee", creator: user_b, report_type: :report)
      
      user_a.reports.must_include(r1.id)
      user_b.reports.must_include(r2.id)
      
      user_a.associate_with!(user_b)
      
      r1.share_with!(user_b)
      
      #user_b should now have 2 reports
      user_b.reports.count.must_equal 2
      
      #user_a should still have 1 report
      user_a.reports.count.must_equal 1
    end
    
    it 'should get all report tags from reports both owned and shared with the user' do
      r1 = Report.create!(name: "1", content: "xxx", creator: user_a, tags: ['1', '2'], report_type: :report)
      r2 = Report.create!(name: "2", content: "xfeee", creator: user_b, tags: ['3', '4'], report_type: :report)
      
      user_a.associate_with!(user_b)
      
      r1.share_with!(user_b)
      
      user_a.report_tags.must_contain_all ['1', '2']
      user_a.report_tags.must_contain_none ['3', '4']
      
      user_b.report_tags.must_contain_all ['1', '2', '3', '4']
    end
    
    it 'should get all report template tags from report templates both owned and shared with the user' do
      rt1 = Report.create!(name: "1", content: "xxx", creator: user_a, tags: ['1', '2'], report_type: :template)
      rt2 = Report.create!(name: "2", content: "xfeee", creator: user_b, tags: ['3', '4'], report_type: :template)
      
      user_a.associate_with!(user_b)
      
      rt1.share_with!(user_b)
      
      user_a.template_tags.must_contain_all ['1', '2']
      user_a.template_tags.must_contain_none ['3', '4']
      
      user_b.template_tags.must_contain_all ['1', '2', '3', '4']
    end
    
    it 'should get all reports with the specified tags' do
      r1 = Report.create!(name: "1", content: "xxx", creator: user_a, tags: ['1', '2'], report_type: :report)
      r2 = Report.create!(name: "2", content: "xfeee", creator: user_a, tags: ['3', '4'], report_type: :report)
      
      reports = user_a.all_reports(['3', '4'])
      reports.count.must_equal 1
    end
    
    it 'should get all templates with the specified tags' do
      rt1 = Report.create!(name: "1", content: "xxx", creator: user_a, tags: ['1', '2'], report_type: :template)
      rt2 = Report.create!(name: "2", content: "xfeee", creator: user_a, tags: ['3', '4'], report_type: :template)
      
      templates = user_a.all_templates(['3', '4'])
      templates.count.must_equal 1
    end
  end
  
  describe 'Report Templates' do
    
    before :each do
      user_a.save!
      user_b.save!
    end
    
    it 'should get all templates, both owned and shared with the user' do
      t1 = Report.create!(name: "1", content: "xxx", creator: user_a, report_type: :template)
      t2 = Report.create!(name: "2", content: "xfeee", creator: user_b, report_type: :template)
      
      #check the owned templates
      user_a.reports.must_include(t1.id)
      user_b.reports.must_include(t2.id)
      
      #share one
      user_a.associate_with!(user_b)
      t1.share_with!(user_b)
      
      #user_b should now have 2 templates
      user_b.reports.count.must_equal 2
      
      #user_a should still have 1 template
      user_a.reports.count.must_equal 1
    end
    
    it 'should get all template tags from reports both owned and shared with the user' do
      t1 = Report.create!(name: "1", content: "xxx", creator: user_a, tags: ['1', '2'], report_type: :template)
      t2 = Report.create!(name: "2", content: "xfeee", creator: user_b, tags: ['3', '4'],report_type: :template)
      
      user_a.associate_with!(user_b)
      
      t1.share_with!(user_b)
      
      user_a.template_tags.must_contain_all ['1', '2']
      user_a.template_tags.must_contain_none ['3', '4']
      
      user_b.template_tags.must_contain_all ['1', '2', '3', '4']
    end
  end
  
  describe 'Associations between users' do
    
    before :each do
      user_a.save!
      user_b.save!
    end
    
    it 'should mark an invitation to associate as accepted when associating from inviter end' do
      user_a.invite_to_associate!(user_b)
      user_a.associate_with!(user_b)
      
      invitation = user_a.get_invitation(user_b)
      
      invitation.wont_be_nil
      invitation.accepted?.must_equal true
    end
    
    it 'should mark an invitation to associate as accepted when associating from invitee end' do
      user_a.invite_to_associate!(user_b)
      user_b.associate_with!(user_a)
      
      invitation = user_a.get_invitation(user_b)
      
      invitation.wont_be_nil
      invitation.accepted?.must_equal true
    end
    
    it 'should associate users such that each is an associate of the other' do
      user_a.associate_with!(user_b)

      user_a.associated_with?(user_b).must_equal true
      user_b.associated_with?(user_a).must_equal true
    end
    
    it 'should disassociate users such that each is no longer an associate of the other' do
      user_a.associate_with!(user_b)
      
      user_a.associated_with?(user_b).must_equal true
      user_b.associated_with?(user_a).must_equal true
      
      user_b.disassociate_with!(user_a)
      
      user_a.associated_with?(user_b).must_equal false
      user_b.associated_with?(user_a).must_equal false
    end
    
    it 'should have associates if some have been added' do
      user_a.associates.must_be_empty
      user_b.associates.must_be_empty
      
      user_a.associate_with!(user_b)
      
      user_a.associates.must_include(user_b.id)
      user_b.associates.must_include(user_a.id)
    end
    
    it 'should handle multiple attempts at the same association gracefully when attempting the same association' do

      user_a.associate_with!(user_b)
      
      user_a.associates.count.must_equal 1
      user_b.associates.count.must_equal 1
      
      user_a.associate_with!(user_b)
      
      user_a.associates.count.must_equal 1
      user_b.associates.count.must_equal 1
    end
    
    it 'should handle multiple attempts at the same association gracefully when attempting the inverse association' do
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
  
  describe 'Invite to associate' do
    
    before :each do
      user_a.save!
      user_b.save!
    end
      
    it 'should throw an exception if attempting to invite self' do
      proc { user_a.invite_to_associate!(user_a) }.must_raise RuntimeError  
    end
    
    it 'should create an invitation when inviting a user to associate' do
      user_a.associate_invitations_sent.must_be_empty
      user_b.associate_invitations_received.must_be_empty
      
      user_a.invite_to_associate!(user_b)
      
      user_a.associate_invitations_sent.wont_be_empty
      user_a.associate_invitations_received.must_be_empty
      
      user_b.associate_invitations_received.wont_be_empty
      user_b.associate_invitations_sent.must_be_empty
    end
    
    it 'should throw an exception if an invitation has already been sent' do
      user_a.invite_to_associate!(user_b)
      
      proc { user_a.invite_to_associate!(user_b) }.must_raise RuntimeError
    end
    
    it 'should throw an exception if the two users are already associated' do
      user_a.associate_with!(user_b)
      
      proc { user_a.invite_to_associate!(user_b) }.must_raise RuntimeError
    end
    
    it 'should know if it has already invited a user' do
      user_a.invite_to_associate!(user_b)
      user_a.has_invited?(user_b).must_equal true
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