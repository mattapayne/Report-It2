CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      provider: 'AWS',               
      aws_access_key_id: ENV['aws_access_key_id'],
      aws_secret_access_key: ENV['aws_secret_access_key'],
      region: ENV['aws_region']
    }
    config.fog_directory  = ENV['aws_bucket_name']                     # required
    config.fog_public     = true                                   # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
    config.delete_tmp_file_after_storage = true
  else
    config.storage = :file
  end
  config.delete_tmp_file_after_storage = true
end