require "test_helper"

describe Report do
    
  def setup_share
    report.save!
    user_a.associate_with!(user_b)  
    report.share_with!(user_b)
  end
  
  let(:user_a) { User.new({first_name: 'Matt', last_name: 'Payne', email: 'test@test.ca', password: '232423', password_confirmation: '232423' }) }
  let(:user_b) { User.new({first_name: 'Other', last_name: 'Other', email: 'other@test.ca', password: '232423', password_confirmation: '232423' })}
  let(:report) { Report.new({ name: "test", content: "test", creator: user_a, report_type: :report }) }

  describe 'Initial state' do
    it 'should initially have a status of draft' do
      report.draft?.must_equal true
    end
  end
  
  describe 'Tags' do
    it 'should know if it has all of the tags specified' do
      report.tags = ['a', 'b', 'c', 'd', 'e']
      report.has_all_tags?(['a', 'b']).must_equal true
    end
    
    it 'should know if it does not have all of the tags specified' do
      report.tags = ['a', 'b', 'c', 'd', 'e']
      report.has_all_tags?(['a', 'x']).must_equal false
    end
  end

  describe 'Validation' do
    it "must be valid if all required fields are present" do
      report.valid?.must_equal true
    end
    
    it 'is invalid if name is not present' do
      report.name = nil
      report.valid?.must_equal false
    end
    
    it 'is invalid if creator is not present' do
      report.creator = nil
      report.valid?.must_equal false
    end
    
  end
  
  describe 'Copy a report' do
    
    it 'should copy fields and return a new instance' do
      other = Report.copy(user_a, report)
      other.name.must_equal "Copy of: #{report.name}"
      other.content.must_equal report.content
      other.creator.id.must_equal user_a.id
      other.report_type.must_equal report.report_type
      other.description.must_equal report.description
      other.tags.must_contain_all report.tags
      other.id.wont_equal report.id
    end
    
    it 'should copy a report and set its status to draft' do
      other = Report.copy(user_a, report)
      other.draft?.must_equal true
    end
    
  end

  describe 'Sharing' do
    
    it 'should know whether it is owned or shared with a specific user when the user is the creator' do
      setup_share
      report.owned_by_or_shared_with?(user_a).must_equal true
    end
    
    it 'should know whether it is owned or shared with a specific user when it has been shared with the user' do
      setup_share
      report.owned_by_or_shared_with?(user_b).must_equal true
    end

    it 'should know whether it is owned or shared with a specific user when it has NOT been shared with the user' do
      report.owned_by_or_shared_with?(user_b).must_equal false
    end
    
    it 'should know whether it is owned or shared with a specific user when it has NOT been shared with the user and the user is not the creator' do
      other = User.new
      report.owned_by_or_shared_with?(other).must_equal false
    end
    
    it 'should share with a user associated with the creator' do
      setup_share
      user_b.all_reports.wont_be_empty
    end
    
    #exercise a bug
    it 'should not change the ownership of the report when shared' do
      report.save!
      
      report.creator.id.must_equal user_a.id
      
      user_a.associate_with!(user_b)

      report.share_with!(user_b)
      
      report.creator.id.must_equal user_a.id      
    end
    
    it 'should not share with a user not associated with the creator' do
      report.save!
      proc { report.share_with!(user_b) }.must_raise RuntimeError
    end
    
    it 'should not share with a user that is also the creator' do
      report.save!
      proc { report.share_with!(user_a) }.must_raise RuntimeError
    end
    
    it 'should unshare a shared report' do
      setup_share
      
      report.unshare_with!(user_b)
      
      user_b.reports.must_be_empty
    end
  end
end
