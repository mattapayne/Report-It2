require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

ENV.update YAML.load_file('config/application.yml')[Rails.env] rescue {}

module ReportIt
  class Application < Rails::Application

  end
end

#non-environment specific settings
ReportIt::Application.configure do
    config.assets.initialize_on_precompile = true
    config.autoload_paths += %W(#{config.root}/lib)
    config.action_mailer.default_url_options = { :host => ENV['mailer_host'] }
    config.action_mailer.delivery_method :smtp
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_deliveries = true
    config.action_mailer.smtp_settings = {
        :address => "smtp.gmail.com",
        :port => "587",
        :domain => ENV['mailer_domain'],
        :enable_starttls_auto => true,
        :authentication => :login,
        :user_name => ENV['mailer_username'],
        :password => ENV['mailer_password']
  }
end
