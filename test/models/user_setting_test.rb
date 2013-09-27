require 'test_helper'

describe UserSetting do
  
  def user_setting_props
    {key: 'key', value: 'value', description: 'descr', validation_rule: 'rule'}
  end
  
  let(:s) { UserSetting.new(user_setting_props) }
  
  describe 'Validation' do
    
    it 'should be valid if all properties are set and valid' do
      s.valid?.must_equal true
    end
    
    it 'should be invalid if key is not set' do
      s.key = nil
      s.valid?.must_equal false
    end
    
    it 'should be invalid if key is less than 3 characters' do
      s.key = 'ab'
      s.valid?.must_equal false
    end
    
  end
  
end