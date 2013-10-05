require "test_helper"

describe Api::V1::SnippetsController do
  
  def create_snippet(user, opts={})
    user.snippets.create!({name: 'Test', content: 'test'}.merge(opts))
  end
  
  before do
    login
  end
  
  describe 'Index' do
    
    it 'should get all snippets for the current user' do
      create_snippet(current_user)
      
      get :index, format: :json
      
      json = JSON.parse(response.body)
      json.must_be_instance_of Array
      json.length.must_equal 1
      response.success?.must_equal true
    end
    
  end
  
  describe 'Create' do
    
    it 'should successfully create a snippet' do
      post :create, format: :json, snippet: {name: "test", content: "content"}
      
      json = JSON.parse(response.body)
      
      response.success?.must_equal true
      snippet = current_user.snippets.first
      snippet.wont_be_nil
      snippet.name.must_equal "test"
    end
    
    it 'should ignore any additional, non-whitelisted params' do
      post :create, format: :json, snippet: {name: "test", content: "content", id: "XXXX", some_random_value: "222322"}
      
      json = JSON.parse(response.body)
      
      response.success?.must_equal true
      snippet = current_user.snippets.first
      snippet.wont_be_nil
      snippet.name.must_equal "test"
    end
    
    it 'should have errors if the snippet is not valid' do
      post :create, format: :json, snippet: {name: "test"}
      
      json = JSON.parse(response.body)
      
      response.success?.must_equal false
      json["messages"].wont_be_nil
    end
    
    it 'should not create an invalid snippet' do
      post :create, format: :json, snippet: {name: "test"}
      
      current_user.snippets.count.must_equal 0
    end
    
  end
  
  describe 'Update' do
    
    it 'should update the correct snippet' do
      snippet = create_snippet(current_user, name: "Old name", content: "Old content")
      
      put :update, id: snippet.id, format: :json, snippet: {name: "New Name", content: "New Content"}
      
      updated_snippet = current_user.snippets.find(snippet.id)
      updated_snippet.wont_be_nil
      updated_snippet.name.must_equal "New Name"
      updated_snippet.content.must_equal "New Content"
    end
    
    it 'should be successful if the snippet was successfully updated' do
      snippet = create_snippet(current_user, name: "Old name", content: "Old content")
      
      put :update, id: snippet.id, format: :json, snippet: {name: "New Name", content: "New Content"}
      
      json = JSON.parse(response.body)
      response.success?.must_equal true
      json["messages"].wont_be_nil
    end
    
    it 'should have errors if the snippet is not valid' do
      snippet = create_snippet(current_user, name: "Old name", content: "Old content")
      
      put :update, id: snippet.id, format: :json, snippet: {name: "", content: ""}
      
      json = JSON.parse(response.body)
      response.success?.must_equal false
      json["messages"].wont_be_nil
    end
    
    it 'should dissallow access to a snippet not owned by the user' do
      user = create_user(first_name: 'Someone', last_name: 'Else', email: 'test@example.ca')
      snippet = create_snippet(user)
      
      put :update, id: snippet.id, format: :json, snippet: {name: "blah", content: "blah"}
      
      json = JSON.parse(response.body)
      response.success?.must_equal false
      response.status.must_equal 406
      json["messages"].wont_be_nil
    end
    
  end
  
  describe 'Destroy' do
    
    it 'should successfully destroy the snippet' do
      snippet = create_snippet(current_user, name: "Blah")
      
      delete :destroy, id: snippet.id, format: :json
    
      json = JSON.parse(response.body)
          
      response.success?.must_equal true
      json["messages"].wont_be_nil
    end
    
    it 'should dissallow access to a snippet not owned by the user' do
      user = create_user(first_name: 'Someone', last_name: 'Else', email: 'test@example.ca')
      snippet = create_snippet(user)
      
      delete :destroy, id: snippet.id, format: :json
      
      json = JSON.parse(response.body)
      response.success?.must_equal false
      response.status.must_equal 406
      json["messages"].wont_be_nil
    end
    
  end
  
end
