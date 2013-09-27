require 'custom_mongoid_helpers'
require 'simple_enum/mongoid'

module Mongoid::Document
  include ReportIt::CustomMongoidHelpers
end