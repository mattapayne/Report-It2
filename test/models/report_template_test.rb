require "test_helper"

describe ReportTemplate do
    
  def setup_share
    report_template.save!
    user_a.associate_with!(user_b)  
    report_template.share_with!(user_b)
  end
  
  let(:user_a) { User.new({first_name: 'Matt', last_name: 'Payne', email: 'test@test.ca', password: '232423', password_confirmation: '232423' }) }
  let(:user_b) { User.new({first_name: 'Other', last_name: 'Other', email: 'other@test.ca', password: '232423', password_confirmation: '232423' })}
  let(:report_template) { ReportTemplate.new(name: 'Template', content: 'Some content', creator: user_a) }   
  
  describe 'Initial state' do
    
    it 'should initially have a status of draft' do
      report_template.status.must_be_nil
      report_template.save!
      report_template.draft?.must_equal true
    end
    
  end
  
  describe 'Tags' do
    it 'should know if it has all of the tags specified' do
      report_template.tags = ['a', 'b', 'c', 'd', 'e']
      report_template.has_all_tags?(['a', 'b']).must_equal true
    end
    
    it 'should know if it does not have all of the tags specified' do
      report_template.tags = ['a', 'b', 'c', 'd', 'e']
      report_template.has_all_tags?(['a', 'x']).must_equal false
    end
  end

  describe 'Validation' do
    it "must be valid if all required fields are present" do
      report_template.valid?.must_equal true
    end
    
    it 'is invalid if name is not present' do
      report_template.name = nil
      report_template.valid?.must_equal false
    end
    
    it 'is invalid if content is not present' do
      report_template.content = nil
      report_template.valid?.must_equal false
    end
    
    it 'is invalid if creator is not present' do
      report_template.creator = nil
      report_template.valid?.must_equal false
    end
    
  end
  
  describe 'Sharing' do
    
    it 'should know whether it is owned or shared with a specific user when the user is the creator' do
      setup_share
      report_template.owned_by_or_shared_with?(user_a).must_equal true
    end
    
    it 'should know whether it is owned or shared with a specific user when it has been shared with the user' do
      setup_share
      report_template.owned_by_or_shared_with?(user_b).must_equal true
    end

    it 'should know whether it is owned or shared with a specific user when it has NOT been shared with the user' do
      report_template.save!
      report_template.owned_by_or_shared_with?(user_b).must_equal false
    end
    
    it 'should know whether it is owned or shared with a specific user when it has NOT been shared with the user and the user is not the creator' do
      other = User.new
      report_template.owned_by_or_shared_with?(other).must_equal false
    end
  
    it 'should share with a user associated with the creator' do
      setup_share
      user_b.report_templates.wont_be_empty
    end
    
    it 'should not change the ownership of the template when shared' do
      #initially owned by user_a
      report_template.creator.id.must_equal(user_a.id)
      
      user_a.associate_with!(user_b)
      report_template.share_with!(user_b)
      
      #still owned by user_a
      report_template.creator.id.must_equal(user_a.id)
    end
    
    it 'should not share with a user not associated with the creator' do
      report_template.creator = user_a
      report_template.save!
      proc { report_template.share_with!(user_b) }.must_raise RuntimeError
    end
    
    it 'should not share with a user that is also the creator' do
      report_template.creator = user_a
      report_template.save!
      proc { report_template.share_with!(user_a) }.must_raise RuntimeError
    end
    
    it 'should unshare a shared template' do
      setup_share
      report_template.unshare_with!(user_b)
      user_b.report_templates.must_be_empty
    end
  end
end
