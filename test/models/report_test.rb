require "test_helper"

describe Report do
  
  def valid_report_params
    { name: 'Report', content: 'Some content', creator: User.new }
  end
  
  def setup_share
    report.creator = user_a
    report.save!
    user_a.associate_with!(user_b)  
    report.share_with!(user_b)
  end
  
  let(:report) { Report.new(valid_report_params) }
  let(:user_a) { User.new({first_name: 'Matt', last_name: 'Payne', email: 'test@test.ca', password: '232423', password_confirmation: '232423' }) }
  let(:user_b) { User.new({first_name: 'Other', last_name: 'Other', email: 'other@test.ca', password: '232423', password_confirmation: '232423' })}

  describe 'Initial state' do
    
    it 'should initially have a status of draft' do
      report.status.must_be_nil
      report.save!
      report.draft?.must_equal true
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

  describe 'Sharing' do
    
    it 'should share with a user associated with the creator' do
      setup_share
      
      report.shares.wont_be_empty
      
      share = SharedReport.where(shared_by: user_a, shared_with: user_b, report: report).first
      
      share.wont_be_nil
      share.shared_by.id.must_equal user_a.id
      share.shared_with.id.must_equal user_b.id
      
      user_a.reports_shared_by_me.wont_be_empty
      user_b.reports_shared_with_me.wont_be_empty
    end
    
    it 'should not share with a user not associated with the creator' do
      report.creator = user_a
      report.save!
      proc { report.share_with!(user_b) }.must_raise RuntimeError
    end
    
    it 'should not share with a user that is also the creator' do
      report.creator = user_a
      report.save!
      proc { report.share_with!(user_a) }.must_raise RuntimeError
    end
    
    it 'should unshare a shared report' do
      setup_share
      
      report.unshare_with!(user_b)
      
      share = report.shares.where(shared_by: user_a, shared_with: user_b).first
      
      share.must_be_nil
      
      share = SharedReport.where(shared_by: user_a, shared_with: user_b, report: report).first
      
      share.must_be_nil
      
      user_a.reports_shared_by_me.must_be_empty
      user_b.reports_shared_with_me.must_be_empty
    end
  end
end
