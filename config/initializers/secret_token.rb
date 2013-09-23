#The ENV['secret_key_base] is set in the config/application.yml file. If this file does not exist, creating it using application.yml.example file as a starting point
ReportIt::Application.config.secret_key_base =  ENV['secret_key_base']
