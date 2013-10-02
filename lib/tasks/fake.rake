require 'fakeout'

desc "Fakeout data"
task :fake => :environment do
  faker = Fakeout::Builder.new

  # fake users
  faker.users(100)
  # real user
  faker.users(1, true, {first_name: "Matt", last_name: "Payne", email: "paynmatt@gmail.com"})
  
  faker.associate(email: "paynmatt@gmail.com", count: 50)

  # fake reports
  faker.reports(1000)
  
  #fake templates
  faker.reports(200, {report_type: :template})

  # report
  puts "Faked!\n#{faker.report}"
end