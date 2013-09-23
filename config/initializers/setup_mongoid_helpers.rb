require 'custom_mongoid_helpers'

module Mongoid::Document
  include ReportIt::CustomMongoidHelpers
end