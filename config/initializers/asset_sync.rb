AssetSync.configure do |config|
  config.aws_access_key_id     = ENV['AWS_ACCESS_KEY_ID']
  config.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  config.fog_directory         = 'wbotelhos'
  config.fog_provider          = 'AWS'
  config.fog_region            = 'sa-east-1'
  config.gzip_compression      = true
  config.manifest              = true
end unless Rails.env.test?