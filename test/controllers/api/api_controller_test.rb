require "test_helper"

class Dummy < Api::ApiController
  
  def test_action
    render json: {value: "nothing"}
  end
  
end

describe Dummy do
  
  before do
    login
    Rails.application.routes.draw do
      root to: "home#index"
      get '/test' => 'dummy#test_action'
    end
  end
  
  after do
    Rails.application.reload_routes!
  end
  
  describe 'API Key check' do
    
    it 'should disallow access if no api key is given' do
      @request.headers['X-Application-API-Key'] = nil
      get :test_action
      response.success?.must_equal false
      response.status.must_equal 401    
    end
    
    it 'should disallow access if incorrect api key is given' do
      @request.headers['X-Application-API-Key'] = 'this is not right!!'
      get :test_action
      response.success?.must_equal false
      response.status.must_equal 401    
    end
    
    it 'should allow access if api key is present' do
      @request.headers['X-Application-API-Key'] = ENV['application_api_key']
      get :test_action
      response.success?.must_equal true
    end
    
  end
  
end