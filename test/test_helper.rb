ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require 'database_cleaner'

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
require "minitest/rails/capybara"

# Uncomment for awesome colorful output
require "minitest/pride"
require 'minitest/mock'
require 'json'

DatabaseCleaner.strategy = :truncation

module HelperMethods
  #Override this in any controller spec where database cleaning is not required
  def requires_cleaning?
    true
  end
  
  def create_report(tags=[], opts={})
    options = { name: "test", content: "test", creator: current_user, status: :draft, report_type: :report }.merge(opts)
    report = Report.create!(options)
    report.tags = tags
    report.save!
    report
  end
  
  def create_user(opts={})
    user = User.create!({first_name: 'Matt', last_name: 'Payne', email: 'test@test.ca', password: '232423', password_confirmation: '232423'}.merge(opts))
    user.signup_token = nil
    user.save!
    user
  end
  
  def login
    user = create_user
    session[:user_id] = user.id
  end
  
  def current_user
    @controller.send(:current_user)
  end
end

module MiniTest::Assertions
  def assert_collection_contains_all(expected, actual)
    expected ||= []
    actual ||= []
    assert expected.all? { |i| actual.include?(i)}, "Expected: #{actual.inspect} to include all from: #{expected.inspect}"
  end
  def assert_collection_contains_none(expected, actual)
    expected ||= []
    actual ||= []
    assert !expected.any? { |i| actual.include?(i)}, "Expected: #{actual.inspect} to NOT include any from: #{expected.inspect}"
  end
end

Array.infect_an_assertion :assert_collection_contains_all, :must_contain_all
Array.infect_an_assertion :assert_collection_contains_none, :must_contain_none

class MiniTest::Spec
  before do
    DatabaseCleaner.clean
  end
end

class ActionController::TestCase
  include ::HelperMethods
  
  before do
    DatabaseCleaner.clean
    @request.headers['X-Application-API-Key'] = ENV['application_api_key'] #Add API key to request headers
  end
end

require "mocha/setup"
