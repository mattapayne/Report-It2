require "test_helper"

describe Api::V1::SettingsController do
 
  before do
    login  
  end
  
  describe 'Index' do
    
    it "should get the current user's settings" do
      get :index, format: :json
      
      json = JSON.parse(response.body)
      
      response.success?.must_equal true
      
      json.must_be_instance_of Array
    end
  end
  
  describe 'Update' do
    
    it 'should only allow updating of the setting value' do
      setting = current_user.settings.first
      
      put :update, id: setting.id.to_s, format: :json, setting: {value: 'test', key: 'also test'}
      
      response.success?.must_equal true
      
      user = User.find(current_user.id)
      original_setting = user.settings.first
      
      original_setting.value.must_equal 'test'
      original_setting.key.must_equal 'image_height'
    end
    
    it 'should have an error if the setting specified does not belong to the user' do
      user = create_user(email: 'test@example.com')
      setting = user.settings.first
      
      put :update, id: setting.id.to_s, format: :json, setting: {value: 'test'}
      
      response.success?.must_equal false
      response.status.must_equal 406
    end
  end
end
