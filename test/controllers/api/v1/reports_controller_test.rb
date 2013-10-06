require "test_helper"

describe Api::V1::ReportsController do

  before do
    login
  end
  
  describe 'Index' do
    
    it 'should construct search params' do
      get :index, format: :json, tags:['a', 'b'], search_term: 'test', report_type: :report, status: :draft, page_number: 2, per_page: 5
      
      search = assigns[:search]
      search.wont_be_nil
      search.tags.must_contain_all ['a', 'b']
      search.search_term.must_equal 'test'
      search.report_type.must_equal :report
      search.status.must_equal :draft
      search.page_number.must_equal 2
      search.per_page.must_equal 5
    end
    
    it 'should have search results' do
      get :index, format: :json, tags:['a', 'b'], search_term: 'test', report_type: :report, status: :draft, page_number: 2, per_page: 5
      json = JSON.parse(response.body)
      json.wont_be_nil
      json.must_be_instance_of Hash
    end
    
    it 'should ask the Report class to perform the search' do
      search_args = ReportSearchParams.new({user: current_user, report_type: :report, status: :draft})
      results = Report.search(search_args)
      Report.expects(:search).returns(results)
      get :index, format: :json, tags:['a', 'b'], search_term: 'test', report_type: :report, status: :draft, page_number: 2, per_page: 5
    end
    
    it 'should be successful' do
      get :index, format: :json, tags:['a', 'b'], search_term: 'test', report_type: :report, status: :draft, page_number: 2, per_page: 5
      response.success?.must_equal true
    end
    
  end
  
  describe 'Create' do
     it 'should successfully create a report' do
      post :create, format: :json, report: {name: "test", content: "content", report_type: :report, status: :draft}
      json = JSON.parse(response.body)
      
      user = @controller.send(:current_user)
      
      response.success?.must_equal true
    
      report = current_user.all_reports.first
      
      report.wont_be_nil
      report.name.must_equal "test"
    end
    
    it 'should ignore any additional, non-whitelisted params' do
      post :create, format: :json, report: {name: "test", content: "content", id: "XXXX", some_random_value: "222322", report_type: :report, status: :draft}
      
      json = JSON.parse(response.body)
      
      response.success?.must_equal true
    
      report = current_user.all_reports.first
      
      report.wont_be_nil
      report.name.must_equal "test"
    end
    
    it 'should have errors if the report is not valid' do
      post :create, format: :json, report: {name: "test"}
      
      json = JSON.parse(response.body)
      
      response.success?.must_equal false
      json["messages"].wont_be_nil
    end
    
    it 'should not create an invalid report' do
      post :create, format: :json, report: {name: "test"}
      
      current_user.reports.must_be_empty
    end
  end
  
  describe 'Update' do
    it 'should update the correct report' do
      report = create_report([], name: "Old name", content: "Old content")
      
      put :update, id: report.id, format: :json, report: {name: "New Name", content: "New Content"}
      
      updated_report = current_user.all_reports.find(report.id)
      updated_report.wont_be_nil
      updated_report.name.must_equal "New Name"
      updated_report.content.must_equal "New Content"
    end
    
    it 'should be successful if the report was successfully updated' do
      report = create_report([], name: "Old name", content: "Old content")
      
      put :update, id: report.id, format: :json, report: {name: "New Name", content: "New Content"}
      
      json = JSON.parse(response.body)
      response.success?.must_equal true
      json["messages"].wont_be_nil
    end
    
    it 'should have errors if the report is not valid' do
      report = create_report([], name: "Old name", content: "Old content")
      
      put :update, id: report.id, format: :json, report: {name: "", content: ""}
      
      json = JSON.parse(response.body)
      response.success?.must_equal false
      json["messages"].wont_be_nil
    end
    
    it 'should dissallow access to a report not owned by the user' do
      user = create_user(first_name: 'Someone', last_name: 'Else', email: 'test@example.ca')
      report = create_report([], creator: user)
      
      put :update, id: report.id, format: :json, report: {name: "blah", content: "blah"}
      
      json = JSON.parse(response.body)
      response.success?.must_equal false
      response.status.must_equal 401
      json["messages"].wont_be_nil
    end
    
    it 'should allow access to a report created by the user' do
      report = create_report()
      
      put :update, id: report.id, format: :json, report: {name: "blah", content: "blah"}
      
      json = JSON.parse(response.body)
      response.success?.must_equal true
    end
    
    it 'should allow access to a report shared with the user' do
      user = create_user(first_name: 'Someone', last_name: 'Else', email: 'test@example.ca')
      current_user.associate_with!(user)
      
      report = create_report()
      
      report.share_with!(user)
      
      put :update, id: report.id, format: :json, report: {name: "blah", content: "blah"}
      
      json = JSON.parse(response.body)
      response.success?.must_equal true
    end
      
  end
  
  describe 'Destroy' do
    
    it 'should not allow a user to delete a report they did not create' do
      user = create_user(first_name: 'Someone', last_name: 'Else', email: 'test@example.ca')
      report = create_report([], creator: user)
      
      delete :destroy, id: report.id, format: :json
      
      response.success?.must_equal false
      response.status.must_equal 401
    end
    
    it 'should not allow a report shared with a user to be deleted by that user' do
      user = create_user(first_name: 'Someone', last_name: 'Else', email: 'test@example.ca')
      
      user.associate_with!(current_user)
      
      report = create_report([], creator: user)
      
      report.share_with!(current_user)
      
      delete :destroy, id: report.id, format: :json
      
      response.success?.must_equal false
      response.status.must_equal 401
    end
    
    it 'should successfully delete the report if the user is the creator of the report' do
      report = create_report
      
      delete :destroy, id: report.id, format: :json
      
      response.success?.must_equal true
    end
    
  end
  
  describe 'New' do
    
    it 'should return the appropriate report for the report type specified' do
      get :new, type: :template
      response.success?.must_equal true
      json = JSON.parse(response.body)
      json['report_type'].must_equal 'template'
    end
    
    it 'should return the json for a new report' do
      get :new, type: :report
      response.success?.must_equal true
      json = JSON.parse(response.body)
      json['new_record'].must_equal true
    end
    
  end
  
  describe 'Edit' do
    
    it 'should return the report requested if the user is the creator' do
      report = create_report
      get :edit, id: report.id
      response.success?.must_equal true
      json = JSON.parse(response.body)
      json['id'].to_s.must_equal report.id.to_s
    end
    
    it 'should return the report requested if the report is shared with the user' do
      user = create_user(first_name: 'Someone', last_name: 'Else', email: 'test@example.ca')
      user.associate_with!(current_user)
      
      report = create_report([], creator: user)
      
      report.share_with!(current_user)
      
      get :edit, id: report.id
      
      response.success?.must_equal true
      json = JSON.parse(response.body)
      json['id'].to_s.must_equal report.id.to_s
    end
    
    it 'should not return the report if the user is not the creator or has not had the report shared with them' do
      user = create_user(first_name: 'Someone', last_name: 'Else', email: 'test@example.ca')
      report = create_report([], creator: user)
      
      get :edit, id: report.id
      
      response.success?.must_equal false
      response.status.must_equal 401
    end
    
    it 'should know that it is not new' do
      report = create_report
      get :edit, id: report.id
      
      json = JSON.parse(response.body)
      json['new_record'].must_equal false
    end
    
  end
  
  describe 'Copy' do
    
    it 'should copy a report if the user is the creator' do
      report = create_report
      
      get :copy, id: report.id
      
      response.success?.must_equal true
    end
    
    it 'should copy the report if the report is shared with the user' do
      user = create_user(first_name: 'Someone', last_name: 'Else', email: 'test@example.ca')
      report = create_report([], creator: user)
      
      user.associate_with!(current_user)
      
      report.share_with!(current_user)
      
      get :copy, id: report.id
      
      response.success?.must_equal true
    end
    
    it 'should not copy a report if the user is neither the creator nor has a share' do
      user = create_user(first_name: 'Someone', last_name: 'Else', email: 'test@example.ca')
      report = create_report([], creator: user)
      
      get :copy, id: report.id
      
      response.success?.must_equal false
      response.status.must_equal 401
    end
    
    it 'should copy the report and make the creator the user doing the copy, regardless of the original creator' do
      user = create_user(first_name: 'Someone', last_name: 'Else', email: 'test@example.ca')
      report = create_report([], creator: user)
      
      user.associate_with!(current_user)
      
      report.share_with!(current_user)
      
      get :copy, id: report.id
      
      json = JSON.parse(response.body)
      json['creator_id'].to_s.must_equal current_user.id.to_s
    end
    
    it 'should copy the appropriate attributes' do
      report = create_report(['a', 'b', 'c'], {name: 'Will get copied', content: 'stuff'})
      
      get :copy, id: report.id
      
      json = JSON.parse(response.body)
      
      json['name'].must_equal "Copy of: #{report.name}"
      json['content'].must_equal report.content
      json['description'].must_equal report.description
      json['tags'].must_contain_all report.tags
      json['report_type'].must_equal report.report_type.to_s
      
    end
    
    it 'should leave the copied report status as draft' do
      report = create_report(['a', 'b', 'c'], {name: 'Will get copied', content: 'stuff', status: :published})
      
      get :copy, id: report.id
      
      json = JSON.parse(response.body)
      
      json['status'].must_equal 'draft'
    end
    
  end
  
end
