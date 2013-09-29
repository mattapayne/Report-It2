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

DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  before :each do
    DatabaseCleaner.clean
  end
end

module MiniTest::Assertions
  def assert_collection_contains_all(collection, other)
    assert other.all? { |i| collection.include?(i)}, "Expected: #{collection.inspect} to include all from: #{other.inspect}"
  end
  def assert_collection_contains_none(collection, other)
    assert !other.any? { |i| collection.include?(i)}, "Expected: #{collection.inspect} to NOT include any from: #{other.inspect}"
  end
end

Array.infect_an_assertion :assert_collection_contains_all, :must_contain_all
Array.infect_an_assertion :assert_collection_contains_none, :must_contain_none
