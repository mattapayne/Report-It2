module ReportIt::CustomMongoidHelpers
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def email_regex
      /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
    end
  end
end