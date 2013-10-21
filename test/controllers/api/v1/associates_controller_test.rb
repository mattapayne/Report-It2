require "test_helper"

describe Api::V1::AssociatesController do

  describe "Index" do
   
    before do
      @user = mock_current_user
    end
    
    def stub_associate_search_results(opts={})
      options = {total_pages: 1, current_page: 1, limit_value: 10}.merge(opts)
      @results = []
      @results.stubs(options)
      @user.stubs(:get_associates).returns(@results)
    end
     
    it "should ask the current user for a list of associates" do
      stub_associate_search_results
      @user.expects(:get_associates).once().returns(@results)
      get "index", format: :json
    end
   
    it "should return a json representation of associates and paging data" do
      stub_associate_search_results
      get "index", format: :json
      json = JSON.parse(response.body)
      json.must_be_instance_of Hash
      json['associates'].must_be_instance_of Array
    end
    
    it "should properly represent initial paging state" do
      stub_associate_search_results
      get "index", format: :json
      json = JSON.parse(response.body)
      json['current_page'].must_equal 1
      json['total_pages'].must_equal 1
      json['has_next'].must_equal false
      json['has_previous'].must_equal false
      json['per_page'].must_equal 10
    end
    
    it "should properly represent paging state when paging data has changed" do
      stub_associate_search_results(total_pages: 2, current_page: 2, limit_value: 20)
      get "index", page_number: 2, per_page: 20, format: :json
      json = JSON.parse(response.body)
      json['current_page'].must_equal 2
      json['total_pages'].must_equal 2
      json['has_next'].must_equal false
      json['has_previous'].must_equal true
      json['per_page'].must_equal 20
    end
   
    it "should be successful under normal circumstances" do
      stub_associate_search_results
      get "index", format: :json
      response.success?.must_equal true
    end
    
    it 'should contruct search params from passed in params' do
      stub_associate_search_results
      @controller.expects(:construct_search_params)
      get "index", page_number: 21, per_page: 5, format: :json
    end
    
  end
 
  describe "Potentials" do
  
    before do
      @user = mock_current_user
    end
      
    def stub_potential_search_results(filter, found_items=nil)
      @results = found_items || []
      @user.stubs(:get_potential_associates).with(filter).returns(@results)
    end
      
    it "should ask the current user to find potential associates based on the passed in query" do
      stub_potential_search_results("x")
      @user.expects(:get_potential_associates).once().with('x').returns(@results)
      get "potentials", q: "x", format: :json
    end
    
    it 'should ensure that potential emails are unique' do
      stub_potential_search_results("x", [stub(email: 'dup@dup.ca'), stub(email: 'dup@dup.ca'), stub(email: 'non-dup@non-dup.ca')])
      get "potentials", q: "x", format: :json
      json = JSON.parse(response.body)
      json.must_be_instance_of Array
      json.must_contain_all ['dup@dup.ca', 'non-dup@non-dup.ca']
      json.length.must_equal 2
    end
    
  end
 
  describe "Destroy" do
  
    def setup_association
      @associate = create_user(email: 'other@test.ca')
      current_user.associate_with!(@associate)
    end
  
    before do
      login
      setup_association
    end
    
    it 'should disassociate two users' do
      current_user.associated_with?(@associate).must_equal true
      @associate.associated_with?(current_user).must_equal true
      
      delete :destroy, id: @associate.id, format: :json
      
      current_user.associated_with?(@associate).must_equal false
      @associate.associated_with?(current_user).must_equal false
    end
   
    it 'should be successful when the disassociation occurs' do
      delete :destroy, id: @associate.id, format: :json
      response.success?.must_equal true
    end
    
    it 'should not be successful when disassociation fails' do
      current_user.disassociate_with!(@associate)
      delete :destroy, id: @associate.id, format: :json
      response.success?.must_equal false
    end
   
  end
 
end
