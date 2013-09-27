require "test_helper"

describe ReportTemplate do
  
  def valid_template_params
    { name: 'Template', content: 'Some content', creator: User.new }
  end
  
  def setup_share
    report_template.creator = user_a
    report_template.save!
    user_a.associate_with!(user_b)  
    report_template.share_with!(user_b)
  end
  
  let(:report_template) { ReportTemplate.new(valid_template_params) }
  let(:user_a) { User.new({first_name: 'Matt', last_name: 'Payne', email: 'test@test.ca', password: '232423', password_confirmation: '232423' }) }
  let(:user_b) { User.new({first_name: 'Other', last_name: 'Other', email: 'other@test.ca', password: '232423', password_confirmation: '232423' })}
    
  
  describe 'Initial state' do
    
    it 'should initially have a status of draft' do
      report_template.status.must_be_nil
      report_template.save!
      report_template.draft?.must_equal true
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
  
    it 'should share with a user associated with the creator' do
      setup_share
      
      report_template.shares.wont_be_empty
      
      share = SharedReportTemplate.where(shared_by: user_a, shared_with: user_b, report_template: report_template).first
      
      share.wont_be_nil
      share.shared_by.id.must_equal user_a.id
      share.shared_with.id.must_equal user_b.id
      
      user_a.templates_shared_by_me.wont_be_empty
      user_b.templates_shared_with_me.wont_be_empty
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
      
      share = report_template.shares.where(shared_by: user_a, shared_with: user_b).first
      
      share.must_be_nil
      
      share = SharedReportTemplate.where(shared_by: user_a, shared_with: user_b, report_template: report_template).first
      
      share.must_be_nil
      
      user_a.templates_shared_by_me.must_be_empty
      user_b.templates_shared_with_me.must_be_empty
    end
  end
end
