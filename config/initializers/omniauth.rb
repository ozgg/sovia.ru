Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, Rails.application.secrets.twitter['api_key'], Rails.application.secrets.twitter['api_secret'], {
      secure_image_url: true,
      image_size: 'original'
  }

  provider :facebook, Rails.application.secrets.fb['app_id'], Rails.application.secrets.fb['app_secret'], {
      scope: 'email,public_profile',
      image_size: 'large',
      secure_image_url: true
  }

  provider :vkontakte, Rails.application.secrets.vk['app_id'], Rails.application.secrets.vk['app_secret'], {
      scope: 'email'
  }

  provider :mail_ru, Rails.application.secrets.mailru['app_id'], Rails.application.secrets.mailru['app_private']
end
