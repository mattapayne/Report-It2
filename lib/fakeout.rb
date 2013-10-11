require 'ffaker'

module Fakeout
  class Builder

    FAKEABLE = %w(User Report)

    attr_accessor :report, :user_cache

    def initialize
      self.report = Reporter.new
      self.user_cache = UserCache.new(preferred_email: "paynmatt@gmail.com")
      clean!
    end
    
    #create associations
    def associate(args)
      email = args[:email]
      count = args[:count]
      
      primary_user = self.user_cache.get_by_email(email)
      
      unless primary_user.present?
        raise "Uable to find user: #{email}. Perhaps you need to generate users first?"
      end
      
      (1...count).each do |i|
        user = self.user_cache.random
        primary_user.associate_with!(user)
      end
    end

    # create users (can be admins)
    def users(count = 1, bypass_signup_token = false, options = {})
      1.upto(count) do
        user = User.new({ email: random_unique_email,
                          first_name: random_first_name,
                          last_name: random_last_name,
                          profile_image_url: '/assets/generic_user.png',
                          password: '232423', 
                          password_confirmation: '232423' }.merge(options))
        !user.save
        if bypass_signup_token
          user.signup_token = nil
          !user.save
        end
        self.user_cache.store(user)
      end
      self.report.increment(:users, count)
    end

    # create reports
    def reports(count = 1, options = {})
      1.upto(count) do
        attributes   = { name: Faker::BaconIpsum.word, 
                         content: random_content,
                         report_type: :report,
                         creator: random_user }.merge(options)
        r = Report.new(attributes)
        r.tags << Faker::Lorem.words(rand(10))
        !r.save
      end
      self.report.increment(:reports, count)
    end

    # cleans all faked data away
    def clean!
      FAKEABLE.map(&:constantize).map(&:destroy_all)
    end

    private
    
    def random_user
      self.user_cache.random
    end
    
    def random_content
      Faker::Lorem.paragraph(2)
    end

    def random_unique_email
      Faker::Internet.email.gsub('@', "+#{User.count}@")
    end
    
    def random_first_name
      Faker::Name.first_name
    end
    
    def random_last_name
      Faker::Name.last_name
    end
  end

  class UserCache < Hash
    
    def initialize(opts={})
      @preferred_email = opts[:preferred_email] || ""
      super(0)
    end
    
    def get_by_email(email)
      user = self.values.find {|u| u.email == email}
      
      unless user.present?
        user = @preferred_user
      end
     
      user
    end
    
    def store(user)
      if user.email == @preferred_email
        @preferred_user = user
        return
      end
      self[user.id] = user
    end
    
    def random
      if @preferred_user.present? && rand(self.keys.length).odd?
        return @preferred_user
      end
      id = self.keys[rand(self.keys.length)]
      self[id]
    end
  end
  
  class Reporter < Hash
    def initialize
      super(0)
    end

    def increment(fakeable, number = 1)
      self[fakeable.to_sym] ||= 0
      self[fakeable.to_sym] += number
    end

    def to_s
      report = ""
      each do |fakeable, count|
        report << "#{fakeable.to_s.classify.pluralize} (#{count})\n" if count > 0
      end
      report
    end
  end
end