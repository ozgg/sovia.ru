VkontakteApi.configure do |config|
  # Authorization parameters (not needed when using an external authorization):
  config.app_id       = Rails.application.secrets.vk['app_id']
  config.app_secret   = Rails.application.secrets.vk['app_secret']
  config.redirect_uri = Rails.application.secrets.vk['redirect_uri']

  # Faraday adapter to make requests with:
  # config.adapter = :net_http

  # Logging parameters:
  # log everything through the rails logger
  config.logger = Rails.logger

  # log requests' URLs
  # config.log_requests = true

  # log response JSON after errors
  # config.log_errors = true

  # log response JSON after successful responses
  # config.log_responses = false
end