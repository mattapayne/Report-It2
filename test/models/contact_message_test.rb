require "test_helper"

describe ContactMessage do
  
  #Note - Do not use a variable named :message in the let() - it must clash with something in the framework. Causes these tests to all break. Stupid.
  let(:msg) { ContactMessage.new({ from: 'Someone', email: 'test@test.ca', subject: 'A subject', message_text: 'some text' }) }
  
  it 'should be valid when all fields are present and correctly set' do
    msg.valid?.must_equal true
  end
  
  it 'is invalid if from is not present' do
    msg.from = nil
    msg.valid?.must_equal false
  end
  
  it 'is invalid if email is not present' do
    msg.email = nil
    msg.valid?.must_equal false
  end
    
  it 'is invalid if subject is not present' do
    msg.subject = nil
    msg.valid?.must_equal false
  end
      
  it 'is invalid if message_text is not present' do
    msg.message_text = nil
    msg.valid?.must_equal false
  end
  
end
