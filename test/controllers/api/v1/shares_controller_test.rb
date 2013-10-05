require "test_helper"

describe Api::V1::SharesController do
  
  before do
    login  
  end

  describe 'Index' do
  
    it 'should render a not found response if the report is not found' do
      get :index, id: 'abc', format: :json
      
      response.success?.must_equal false
      response.status.must_equal 406
    end
    
    it 'should render a not permitted response if the user is not the report creator or have it shared' do
      user = create_user(first_name: 'Someone', last_name: 'Else', email: 'test@example.com')
      report = create_report([], creator: user)
      
      get :index, id: report.id, format: :json
      
      response.success?.must_equal false
      response.status.must_equal 401
    end
    
    it 'should render json containing shares and potential shares' do
      report = create_report
      
      get :index, id: report.id, format: :json

      json = JSON.parse(response.body)
      response.success?.must_equal true
      json["users"].wont_be_nil
    end
    
  end
  
  describe 'Update' do
    
    it 'should render a not found response if the report is not found' do
      put :update, id: 'abc', format: :json
      
      response.success?.must_equal false
      response.status.must_equal 406
    end
    
    it 'should render a not permitted response if the user is not the report creator or have it shared' do
      user = create_user(first_name: 'Someone', last_name: 'Else', email: 'test@example.com')
      report = create_report([], creator: user)
      
      put :update, id: report.id, format: :json
      
      response.success?.must_equal false
      response.status.must_equal 401
    end
    
    it 'should not allow the share when the creator of the report and the user to be shared with are not associated' do
      report = create_report
      user = create_user(first_name: 'Someone', last_name: 'Else', email: 'test@example.com')

      put :update, id: report.id, format: :json, share: {user_id: user.id.to_s, shared: true}
      
      json = JSON.parse(response.body)
      
      json["messages"].wont_be_nil
      response.success?.must_equal false
    end
    
    it 'should successfully process an update to share with a user' do
      report = create_report
      user = create_user(first_name: 'Someone', last_name: 'Else', email: 'test@example.com')
      current_user.associate_with!(user)
      
      put :update, id: report.id, format: :json, share: {user_id: user.id.to_s, shared: true}
      
      json = JSON.parse(response.body)
      
      json["messages"].wont_be_nil
      response.success?.must_equal true
    end
    
    it 'should successfully process an update to unshare with a user' do
      report = create_report
      user = create_user(first_name: 'Someone', last_name: 'Else', email: 'test@example.com')
      current_user.associate_with!(user)
      report.share_with!(user)
      
      put :update, id: report.id, format: :json, share: {user_id: user.id.to_s, shared: false}
      
      json = JSON.parse(response.body)
      
      json["messages"].wont_be_nil
      response.success?.must_equal true
    end
    
  end
  
end