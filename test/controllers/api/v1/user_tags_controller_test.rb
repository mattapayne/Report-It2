require "test_helper"

describe Api::V1::UserTagsController do
  
  describe "Index" do

    before do
      login
    end
    
    it 'should response with json containing tags' do
      create_report(['a', 'b', 'c'])
      get 'index', type: "report", format: :json
      json = JSON.parse(response.body)
      json.must_be_instance_of Array
      json.must_contain_all ['a', 'b', 'c']
    end
    
    it 'should respond with tags specific to the report type' do
      create_report(['a', 'b', 'c'], {report_type: :template})
      get 'index', type: "template", format: :json
      json = JSON.parse(response.body)
      json.must_be_instance_of Array
      json.must_contain_all ['a', 'b', 'c']
    end
    
    it 'should respond with tags specific to the supplied filter' do
      create_report(['a', 'b', 'c'])
      get 'index', type: 'report', query: 'a', format: :json
      json = JSON.parse(response.body)
      json.must_be_instance_of Array
      json.must_contain_all ['a']
      json.must_contain_none ['b', 'c']
    end
    
    it 'should handle no filter being present' do
      create_report(['a', 'b', 'c'])
      get 'index', type: 'report', query: nil, format: :json
      json = JSON.parse(response.body)
      json.must_be_instance_of Array
      json.must_contain_all ['a', 'b', 'c']
    end
    
    it 'should only return unique tags' do
      create_report(['a', 'b', 'c'], name: "Report #1")
      create_report(['a', 'b', 'e', 'x'], name: "Report #2")              
      get 'index', type: 'report', format: :json
      json = JSON.parse(response.body)
      json.must_be_instance_of Array
      json.length.must_equal 5
      json.must_contain_all ['a', 'b', 'c', 'e', 'x']
    end
    
  end
  
end
