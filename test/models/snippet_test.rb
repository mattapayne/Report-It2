require "test_helper"

describe Snippet do
  
  def snippet_properties
    { creator: User.new, name: 'Snippet', content: 'Content' }
  end
  
  let(:s) { Snippet.new(snippet_properties) }

  it "is valid if all properties are present" do
    s.valid?.must_equal true
  end
  
  it 'is invalid if creator is not set' do
    s.creator = nil
    s.valid?.must_equal false
  end
  
  it 'is invalid if name is not set' do
    s.name = nil
    s.valid?.must_equal false
  end
  
  it 'is invalid if content is not set' do
    s.content = nil
    s.valid?.must_equal false
  end
  
end