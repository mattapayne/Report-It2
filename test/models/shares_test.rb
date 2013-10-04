require "test_helper"

describe Shares do
  
  def get_some_users(count=10)
    users = []
     (1..count).each do |i|
      users << build_user(i)
    end
    users
  end
  
  def build_user(index)
    User.new(first_name: "First #{index}", last_name: "Last #{index}", email: "user#{index}@example.com") 
  end
  
  it 'should handle nil arguments in the constructor gracefully' do
    @shares = Shares.new(nil, nil)
    @shares.users.must_be_empty
  end
  
  it 'should correctly process users that have shares' do
    @shares = Shares.new(get_some_users, [])
    @shares.users.each {|u| u.has_share.must_equal true }
  end
  
  it 'should correctly process users that do not have shares' do
    @shares = Shares.new([], get_some_users)
    @shares.users.each {|u| u.has_share.must_equal false }
  end
  
  it 'should correctly process users with shares and those without' do
    @shares = Shares.new(get_some_users(5), get_some_users(5))
    with_share = @shares.users.select { |u| u.has_share }
    without_share = @shares.users.select { |u| !u.has_share}
    with_share.count.must_equal 5
    without_share.count.must_equal 5
  end

end