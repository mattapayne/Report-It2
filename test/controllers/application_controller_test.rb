require "test_helper"

describe HomeController do
  
  describe 'Any request' do
    
    it 'must have set the appropriate common variables in all request' do
      [:index, :about, :contact].each do |r|
        get r
        assigns[:active_page].wont_be_nil
        assigns[:page_title].wont_be_nil
      end
    end
    
  end
end