class Shares
  include ActiveModel::Model
  include ActiveModel::SerializerSupport

  attr_accessor :users
  
  def initialize(existing_shares, potential_shares)
    existing_shares ||= []
    potential_shares ||= []
    @users = []
    existing_shares.each {|u| @users << construct_user(u, has_share: true) }
    potential_shares.each {|u| @users << construct_user(u, has_share: false) }
  end
  
  private
  
  def construct_user(user, opts={})
    ShareUser.new({
                    id: user.id,
                    email: user.email,
                    gravatar_url: user.gravatar_url,
                    full_name: user.full_name
                  }.
                  merge(opts))
  end
  
end